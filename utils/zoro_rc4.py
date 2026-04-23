import random

def KSA(key):
    """Key Scheduling Algorithm (KSA) para RC4"""
    key_length = len(key)
    S = list(range(256))  # Inicialización del estado S
    j = 0
    for i in range(256):
        j = (j + S[i] + key[i % key_length]) % 256
        S[i], S[j] = S[j], S[i]  # Intercambio de valores en S
    return S

def PRGA(S, length):
    """Pseudo-Random Generation Algorithm (PRGA) para generar la secuencia de clave"""
    i = j = 0
    key_stream = []
    for _ in range(length):
        i = (i + 1) % 256
        j = (j + S[i]) % 256
        S[i], S[j] = S[j], S[i]  # Intercambio
        key_stream.append(S[(S[i] + S[j]) % 256])
    return key_stream

def rc4_encrypt(plaintext, key):
    """Función para cifrar y descifrar usando RC4"""
    key = [ord(c) for c in key]  # Convertimos la clave a valores numéricos
    S = KSA(key)
    key_stream = PRGA(S, len(plaintext))

    ciphertext = bytes([ord(plaintext[i]) ^ key_stream[i] for i in range(len(plaintext))])
    return ciphertext

def rc4_decrypt(ciphertext, key):
    """Descifrado en RC4 (se usa la misma función)"""
    # DESCIFRADO DE RC4
    key = [ord(c) for c in key]  # Convertimos la clave a valores numéricos
    S = KSA(key)
    key_stream = PRGA(S, len(ciphertext))

    plaintext = bytes([ciphertext[i] ^ key_stream[i] for i in range(len(ciphertext))])
    return plaintext

def generate_rc4(plaintext, key):
    ciphertext = rc4_encrypt(plaintext, key)
    return ciphertext