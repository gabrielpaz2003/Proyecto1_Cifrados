# ⚔️ Guía de Desafío: Roronoa Zoro

Zoro es conocido por su estilo de tres espadas y su resistencia. Este desafío utiliza **RC4**, un cifrado de flujo clásico.

**⚠️ IMPORTANTE:** Para acceder a este desafío, necesitas haber resuelto el desafío de **Luffy**.

## 🎯 Objetivo

Recuperar:
1.  El texto oculto en el **Poneglyph**.
2.  La **Flag** final del desafío (cifrada con RC4).

---

## 🧭 Paso 1: El Laberinto

Al igual que Zoro siempre se pierde, tú tendrás que encontrar el camino correcto en `challenges/zoro/`.
*   Navega por las carpetas hasta encontrar `flag.txt` y el archivo `.zip` del Poneglyph.
*   Ignora los archivos falsos.

---

## 🗿 Paso 2: El Poneglyph

1.  **Descomprimir:**
    *   El archivo zip está protegido con contraseña.
    *   **La contraseña es:** La **FLAG** que obtuviste en el desafío de **Luffy** (formato `FLAG_...`).
2.  **Extraer:** Obtén el texto hexadecimal de los metadatos EXIF de la imagen.
    *   *Tip:* Puedes usar el script `utils/extract_text_from_image.py`.
3.  **Descifrar Texto de Imagen:**
    *   **¡OJO!** El texto oculto en la imagen se cifra usando **XOR** con tu carné (igual que en el reto de Luffy).

---

## 🚩 Paso 3: La Flag (RC4)

El archivo `flag.txt` contiene bytes hexadecimales cifrados con **RC4**.

### ¿Cómo resolverlo?

1.  **El Algoritmo:** RC4 genera un keystream que se combina con el texto plano mediante XOR.
2.  **La Clave:** Es tu **número de carné**.
3.  **Herramientas:**
    *   Usa `utils/zoro_rc4.py`.
    *   Este script contiene funciones para generar el keystream y cifrar/descifrar.

### Instrucciones para el estudiante:
1.  Abre `utils/zoro_rc4.py` y analiza cómo funciona `rc4_encrypt`.
2.  Crea un script que use esta función.
3.  Lee el contenido hexadecimal de `flag.txt`.
4.  Convierte el hex a bytes.
5.  Llama a la función de descifrado pasando los bytes cifrados y tu carné como clave.

```python
# Ejemplo conceptual
from utils.zoro_rc4 import generate_rc4

cipher_hex = "..." # Contenido del flag.txt
cipher_bytes = bytes.fromhex(cipher_hex)
key = "TU_CARNE"

# RC4 es simétrico, cifrar y descifrar es lo mismo
print(generate_rc4(cipher_bytes, key).decode())
```
