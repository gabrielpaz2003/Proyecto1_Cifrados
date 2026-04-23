# 💰 Guía de Desafío: Nami

Nami es la navegante y tesorera. Ella utiliza **ChaCha20**, un estándar moderno de cifrado.

**⚠️ IMPORTANTE:** Para acceder a este desafío, necesitas haber resuelto el desafío de **Usopp**.

## 🎯 Objetivo

Recuperar:
1.  El texto oculto en el **Poneglyph**.
2.  La **Flag** final del desafío (cifrada con ChaCha20).

---

## 🧭 Paso 1: Búsqueda

Encuentra el tesoro en `challenges/nami/`. Busca el `flag.txt` y el `.zip` correcto.

---

## 🗿 Paso 2: El Poneglyph

1.  **Descomprimir:**
    *   El archivo zip está protegido con contraseña.
    *   **La contraseña es:** La **FLAG** que obtuviste en el desafío de **Usopp** (formato `FLAG_...`).
2.  **Descifrar Imagen:**
    *   Extrae el EXIF.
    *   Descifra usando **XOR** con tu carné.
    *   Usa `utils/extract_text_from_image.py`.

---

## 🚩 Paso 3: La Flag (ChaCha20)

El archivo `flag.txt` contiene el texto cifrado. ChaCha20 requiere una **Clave (Key)** y un **Nonce**.

### ¿Cómo resolverlo?

1.  **Herramientas:**
    *   Revisa `utils/nami_chacha.py`.
    *   Usa la librería `Crypto.Cipher.ChaCha20` (de `pycryptodome`).

2.  **Clave y Nonce:**
    *   El script `utils/nami_chacha.py` tiene una función `generate_key_nonce(user_id)` que deriva ambos valores de tu **carné**.

3.  **Descifrado:**
    *   Usa la función `chacha20_decrypt(ciphertext, user_id)` incluida en el script.

### Instrucciones para el estudiante:
1.  Instala: `pip install pycryptodome`.
2.  Crea un script que importe `chacha20_decrypt`.
3.  Lee el contenido de `flag.txt` (hex).
4.  Convierte a `bytes`.
5.  Descifra usando tu carné.

```python
from utils.nami_chacha import chacha20_decrypt

with open("ruta/a/flag.txt", "r") as f:
    hex_content = f.read().strip()

cipher_bytes = bytes.fromhex(hex_content)
student_id = "TU_CARNE"

print(chacha20_decrypt(cipher_bytes, student_id))
```
