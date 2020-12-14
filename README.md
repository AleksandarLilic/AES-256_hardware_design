# AES-256 Hardware Design  

**Description:**

VHDL hardware design of the AES-256 encryption algorithm for ASIC or FPGA implementation

Done as a part of the Graduate thesis

AES is implemented as a two-part design - *key schedule* and *encryption*. Both were separately functionally verified and verified again when assembled. Project is then expanded with *data loading* block, which takes 128-bit ciphertext and sends it down an 8-bit bus in 16 packets. 

**Status:**  
Basic functional verification is done with all of the used vectors passing

**Further development:**  
Self-checking testbench, more test cases, coverage
