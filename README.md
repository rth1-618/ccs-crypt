# Cryptographic Suite & GUI Simulator in MATLAB

A comprehensive, interactive cryptographic engineering suite built in MATLAB App Designer. This project provides a hands-on environment for exploring classical ciphers, symmetric block ciphers, message authentication codes, asymmetric public-key cryptosystems, and hybrid envelope key management. Designed with a modular architecture, every cryptographic primitive—from SHA-256 hashing to RSA key generation—is built from first principles without relying on external high-level toolboxes.

---

## 1. Project Overview & Architecture

The application provides a unified graphical interface (`mainApp.mlapp`) featuring tabbed navigation, real-time input validation, and interactive state management. Users can perform step-by-step encryption, decryption, hashing, key exchange, and envelope wrapping across both text data and arbitrary binary media files (e.g., images).

### System Architecture & Operational Layers

* **Graphical User Interface Layer (`mainApp.mlapp`)**: Built with MATLAB App Designer, coordinating user interactions, modular tab navigation, input validation, and state reset controls.
* **Classical & Stream Cipher Engine**: Implements Caesar, One-Time Pad (OTP), and bitwise XOR stream ciphers supporting both character arrays and binary pixel matrices.
* **Symmetric Block Cipher Engine**: Implements the Data Encryption Standard (DES) in Electronic Codebook (ECB) mode, complete with custom subkey schedules, S-box permutations, and Feistel rounds.
* **Message Authentication & Hash Engine**: Constructs Keyed-Hash Message Authentication Codes (HMAC-SHA256) via a pure MATLAB SHA-256 compression pipeline using explicit inner and outer padding.
* **Asymmetric & Key Exchange Engine**: Executes RSA public-key encryption and Diffie-Hellman key derivation, supported by custom modular arithmetic subroutines.
* **Hybrid Envelope Encryption Layer**: Combines symmetric payload encryption (AES-GCM) with asymmetric key management service (KMS) operations to protect data encryption keys (DEKs).

---

## 2. Quick Start & System Requirements

### System Requirements
* MATLAB R2021a or newer.
* MATLAB App Designer environment (included in standard MATLAB installation).
* No external software toolboxes required.

### Launch Instructions
1. Clone or download the repository into your local MATLAB workspace.
2. Open MATLAB and navigate to the project root folder.
3. Open the main application file:
   ```matlab
   open mainApp.mlapp
   ```
4. Click the **Run** button in the App Designer canvas to start the application interface.

---

## 3. Core Cryptographic Modules & Mathematical Formulations

### 3.1 Classical & Stream Ciphers

#### Caesar Cipher
A classic monoalphabetic substitution cipher shifting alphabetic characters over a 26-letter modulo space while preserving non-alphabetic characters and letter casing.

$$\text{Encryption: } C_i = (P_i + s) \pmod{26}$$

$$\text{Decryption: } P_i = (C_i - s) \pmod{26}$$

* **Implementation Files**: `crypt/caesarEncrypt.m`, `crypt/caesarDecrypt.m`
* **Key Parameters**: Integer shift $s \in [1, 25]$.

#### One-Time Pad (OTP)
A symmetric cipher offering information-theoretic security when configured with a truly random, non-repeating key matching the exact length of the plaintext message.

$$\text{Encryption: } C_i = (P_i + K_i) \pmod{26}$$

$$\text{Decryption: } P_i = (C_i - K_i) \pmod{26}$$

* **Implementation Files**: `crypt/otpEncrypt.m`, `crypt/otpDecrypt.m`
* **Key Parameters**: $\text{length}(K) = \text{length}(P)$. Keys are generated per session and preserved for decryption.

#### Bitwise XOR Cipher (Text & Binary Images)
A fast stream cipher operating on byte arrays via bitwise exclusive-OR operations.

$$\text{Encryption / Decryption: } C = P \oplus K \quad \Longleftrightarrow \quad P = C \oplus K$$

* **Implementation Files**: `crypt/xorBytes.m`, `io/encoding/*`
* **Features**: Operates identically on text byte streams and raw image pixel arrays, enabling full visual obfuscation and lossless reconstruction.

---

### 3.2 Symmetric Block Ciphers: DES (Data Encryption Standard)

A full implementation of DES operating in Electronic Codebook (ECB) mode, featuring a 16-round Feistel network, custom S-boxes, subkey schedules, and parity-bit checks.

| Parameter | Specification |
| :--- | :--- |
| **Block Size** | 64 bits |
| **Key Size** | 56 key bits + 8 parity bits (64 bits total) |
| **Cipher Mode** | Electronic Codebook (ECB) |
| **Padding Scheme** | PKCS-style zero-padding for incomplete blocks |
| **Supported Inputs** | ASCII text strings and binary image byte matrices |

* **Implementation Files**:
  * `crypt/des/desEncryptECB.m` — Main ECB block encryption driver.
  * `crypt/des/desDecryptECB.m` — Main ECB block decryption driver.
  * `crypt/des/desGenerateSubkeys.m` — 16-round subkey schedule generator.
  * `crypt/des/desBlock.m` — Single 64-bit Feistel round routine.

---

### 3.3 Message Authentication: HMAC-SHA256

A Keyed-Hash Message Authentication Code (HMAC) constructed from first principles using a custom SHA-256 hash algorithm.

$$\text{HMAC}(K, M) = H\Big((K \oplus \text{opad}) \mathbin{\Vert} H\big((K \oplus \text{ipad}) \mathbin{\Vert} M\big)\Big)$$

Where:
* $\text{ipad} = \text{0x36}$ repeated to match the 64-byte block size of SHA-256.
* $\text{opad} = \text{0x5C}$ repeated to match the 64-byte block size of SHA-256.
* $H(\cdot)$ denotes the custom SHA-256 compression function.

* **Implementation Files**:
  * `crypt/hmacSHA256.m` — Outer HMAC construction driver.
  * `crypt/sha256_bytes.m` — Byte-stream converter for hashing.
  * `crypt/my_sha256.m` — Native SHA-256 hash engine.

---

### 3.4 Asymmetric Public-Key Cryptography & Key Exchange

#### RSA Cryptosystem
An asymmetric public-key system supporting prime selection, key generation, modular inverse computation, text chunking, and Base64 display encoding.

$$\text{Key Generation: } n = p \cdot q, \quad \phi(n) = (p-1)(q-1), \quad e \cdot d \equiv 1 \pmod{\phi(n)}$$

$$\text{Encryption: } C = M^e \pmod{n}$$

$$\text{Decryption: } M = C^d \pmod{n}$$

* **Implementation Files**:
  * `crypt/rsa/powmod.m` — Modular exponentiation via square-and-multiply.
  * `crypt/rsa/egcd.m` — Extended Euclidean Algorithm.
  * `crypt/rsa/modInverse.m` — Modular multiplicative inverse calculator.
  * `crypt/rsa/generateRSAKeys.m` — RSA key pair generator producing $(e, n)$ and $(d, n)$.
  * `crypt/rsa/rsaEncryptText.m` & `crypt/rsa/rsaDecryptText.m` — Text chunking encryption/decryption drivers.

#### Diffie–Hellman Key Exchange
A key agreement protocol allowing two parties to derive a shared secret key over an unencrypted channel.

$$\text{Public Parameters: } p \text{ (prime modulus)}, \quad g \text{ (generator)}$$

$$\text{Alice Public Exchange: } A = g^a \pmod{p}$$

$$\text{Bob Public Exchange: } B = g^b \pmod{p}$$

$$\text{Derived Shared Secret: } K = B^a \pmod{p} = A^b \pmod{p} = g^{ab} \pmod{p}$$

* **Implementation Files**:
  * `crypt/diffie-hellman/SetPublicParams.m` — Public modulus and generator setup.
  * `crypt/diffie-hellman/ExchangeAlice.m` & `ExchangeBob.m` — Public key computation.
  * `crypt/diffie-hellman/ComputeSharedAlice.m` & `ComputeSharedBob.m` — Shared secret derivation.
  * `crypt/diffieHellman.m` — Main Diffie-Hellman execution script.

---

### 3.5 Hybrid Envelope Encryption & Key Management

A hybrid cryptographic module combining symmetric payload encryption with asymmetric key protection to emulate cloud Key Management Service (KMS) workflows.

* **Protocol Flow**:
  1. A random Data Encryption Key (DEK) is generated for bulk payload encryption.
  2. Plaintext data is encrypted using AES in Galois/Counter Mode (AES-GCM) for authenticated encryption.
  3. The DEK is wrapped (encrypted) using RSA or a derived Diffie-Hellman secret key.
  4. The encrypted package (Wrapped DEK + Encrypted Payload + Authentication Tag) is transmitted and unwrapped by the KMS module.
* **Implementation Files**:
  * `crypt/envelope/KMS.m` — Key Management Service module.
  * `crypt/envelope/AES_DHill/*` — Symmetric payload encryption routines.
  * `crypt/envelope/GCM_BlockCipher/*` — Authenticated GCM block cipher implementation.

---

## 4. Directory Structure & File Index

```
.
├── mainApp.mlapp                  # Main MATLAB App Designer GUI application
├── crypt/                         # Core cryptographic algorithm library
│   ├── caesarEncrypt.m            # Caesar cipher encryption function
│   ├── caesarDecrypt.m            # Caesar cipher decryption function
│   ├── otpEncrypt.m               # One-Time Pad encryption function
│   ├── otpDecrypt.m               # One-Time Pad decryption function
│   ├── xorBytes.m                 # Bitwise XOR stream cipher function
│   ├── hmacSHA256.m               # Outer HMAC-SHA256 wrapper
│   ├── sha256_bytes.m             # Byte-stream wrapper for SHA-256
│   ├── my_sha256.m                # Pure MATLAB SHA-256 hash algorithm
│   ├── diffieHellman.m            # Main Diffie-Hellman key exchange script
│   ├── des/                       # DES block cipher implementation
│   │   ├── desEncryptECB.m        # DES ECB encryption driver
│   │   ├── desDecryptECB.m        # DES ECB decryption driver
│   │   ├── desGenerateSubkeys.m   # 16-round subkey schedule generator
│   │   └── desBlock.m             # Feistel round routine
│   ├── rsa/                       # RSA public-key cryptosystem
│   │   ├── powmod.m               # Modular exponentiation utility
│   │   ├── egcd.m                 # Extended Euclidean algorithm
│   │   ├── modInverse.m           # Modular multiplicative inverse calculator
│   │   ├── generateRSAKeys.m      # RSA key pair generator
│   │   ├── rsaEncryptText.m       # Text chunking RSA encryption driver
│   │   └── rsaDecryptText.m       # Text chunking RSA decryption driver
│   ├── diffie-hellman/            # Modular Diffie-Hellman routines
│   │   ├── SetPublicParams.m      # Public parameter configuration
│   │   ├── ExchangeAlice.m        # Alice public value computation
│   │   ├── ExchangeBob.m          # Bob public value computation
│   │   ├── ComputeSharedAlice.m   # Alice shared key calculation
│   │   └── ComputeSharedBob.m     # Bob shared key calculation
│   └── envelope/                  # Hybrid envelope encryption module
│       ├── KMS.m                  # Key Management Service simulator
│       ├── AES_DHill/             # Symmetric payload encryption drivers
│       └── GCM_BlockCipher/       # Authenticated GCM block cipher routines
└── io/
    └── encoding/                  # Text and image byte encoding utilities
```

---

## 5. Implementation & Verification Highlights

* **Pure MATLAB Implementations**: All mathematical routines—including SHA-256 bitwise rotations, DES subkey generation, and extended Euclidean modular inverses—are coded natively in MATLAB without relying on Toolbox dependencies.
* **Image Encryption Capability**: The XOR and DES engines support byte-level image processing, demonstrating total visual obfuscation while guaranteeing bit-exact restoration upon decryption.
* **Modular Educational Architecture**: Key exchange and asymmetric functions explicitly separate parameter initialization, public exchange, and secret derivation steps for straightforward code inspection and debugging.
