import random
import sys
import binascii
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes

DEFAULT_SEED = 42
TESTS_GEN = 1000

def get_seed_from_cli():
    if len(sys.argv) < 2:
        print(f"Seed not specified. Using default seed: {DEFAULT_SEED}.")
        return DEFAULT_SEED
    
    seed_arg = sys.argv[1]
    try:
        seed = int(seed_arg)
    except ValueError:
        print(f"Seed must be an integer. Using default seed: {DEFAULT_SEED}.")
        return DEFAULT_SEED

    return seed

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

seed = get_seed_from_cli()
#key = '000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f'
key = generate_random_hex(seed=seed, k=64)
with open('key_gen.txt', 'w') as key_file:
    key_file.write(key + '\n')
with open('seed.txt', 'w') as seed_file:
    seed_file.write(str(seed) + '\n')

# generate plaintext
plaintext_gen = []
for i in range(TESTS_GEN):
    seed += 1
    plaintext_gen.append(generate_random_hex(seed=seed))

# generate ciphertext
ciphertext_gen = []
for i in range(TESTS_GEN):
    hex_plaintext = plaintext_gen[i]
    encrypted = aes256_encrypt(key, hex_plaintext)
    ciphertext_gen.append(binascii.hexlify(encrypted).decode('utf-8'))

with open('plaintext_gen.txt', 'w') as pt_file, open('ciphertext_gen.txt', 'w') as ct_file:
    for i in range(TESTS_GEN):
        pt_file.write(plaintext_gen[i] + '\n')
        ct_file.write(ciphertext_gen[i] + '\n')
