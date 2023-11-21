import random
import sys
import binascii
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

CIPHERTEXT_VALUES = 1000

def get_args_from_cli():
    if len(sys.argv) < 3:
        print(f"Usage: python script.py <seed> <id>")
        sys.exit(1)

    seed_arg = sys.argv[1]
    id_arg = sys.argv[2]

    try:
        seed = int(seed_arg)
    except ValueError:
        print("Seed must be an integer.")
        sys.exit(1)

    return seed, id_arg

def generate_random_hex(seed=None, k=32):
    random.seed(seed)
    random_hex = ''.join(random.choices('0123456789abcdef', k=k))
    return random_hex

def aes256_encrypt(hex_key, hex_plaintext):
    plaintext = binascii.unhexlify(hex_plaintext)
    key = binascii.unhexlify(hex_key)

    if len(key) != 32:
        raise ValueError("Key must be 32 bytes (256 bits) long for AES-256.")
    if len(plaintext) != 16:
        raise ValueError("Plaintext must be 16 bytes long.")

    # create a cipher object using the key and ECB mode
    cipher = Cipher(algorithms.AES(key), modes.ECB())
    # create an encryptor
    encryptor = cipher.encryptor()
    # perform the encryption and get the encrypted bytes
    return encryptor.update(plaintext) + encryptor.finalize()

def main(seed, id):
    #key = '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f'
    key = generate_random_hex(seed=seed, k=64)
    with open(f't_{id}_key_gen.txt', 'w') as key_file:
        key_file.write(key + '\n')
    with open(f't_{id}_seed.txt', 'w') as seed_file:
        seed_file.write(str(seed) + '\n')

    # generate plaintext
    plaintext_gen = []
    for i in range(CIPHERTEXT_VALUES):
        seed += 1
        plaintext_gen.append(generate_random_hex(seed=seed))

    # generate ciphertext
    ciphertext_gen = []
    for i in range(CIPHERTEXT_VALUES):
        hex_plaintext = plaintext_gen[i]
        encrypted = aes256_encrypt(key, hex_plaintext)
        ciphertext_gen.append(binascii.hexlify(encrypted).decode('utf-8'))

    with open(f't_{id}_plaintext_gen.txt', 'w') as pt_file, open(f't_{id}_ciphertext_gen.txt', 'w') as ct_file:
        for i in range(CIPHERTEXT_VALUES):
            pt_file.write(plaintext_gen[i] + '\n')
            ct_file.write(ciphertext_gen[i] + '\n')

if __name__ == "__main__":
    seed, id = get_args_from_cli()
    main(seed, id)
