# 🏴‍☠️ Guía de Desafío: Monkey D. Luffy

Este desafío está diseñado para probar tus habilidades básicas de **exploración de archivos**, **análisis de metadatos** y **criptografía simple (XOR)**.

## 🎯 Objetivo

Tu misión es recuperar dos piezas de información:
1.  El texto oculto en el **Poneglyph** (una imagen).
2.  La **Flag** final del desafío.

---

## 🧭 Paso 1: Exploración y Búsqueda

El primer obstáculo es encontrar los archivos correctos. El script de generación ha creado un "laberinto" de carpetas bajo `challenges/luffy/`.

1.  Navega por las carpetas (que tienen nombres de lugares de One Piece).
2.  Busca dos archivos específicos:
    *   Un archivo de texto: `flag.txt`
    *   Un archivo comprimido: `data_xxxx.zip` (donde xxxx son caracteres aleatorios).

**⚠️ Cuidado:** Hay archivos falsos ("decoys"). Si encuentras una imagen que dice "Este poneglyph no es el que buscas", sigue buscando.

---

## 🗿 Paso 2: El Poneglyph

Una vez encuentres el archivo zip correcto:

1.  **Descomprimir:**
    *   El archivo está protegido con contraseña.
    *   *Pista:* La contraseña es el nombre del tesoro que todos buscan (en minúsculas).
    *   Dentro encontrarás una imagen `.jpeg`.

2.  **Análisis de Metadatos (Steganography/Forensics):**
    *   La imagen tiene un texto visible, pero está incompleto o cifrado visualmente.
    *   La información real está oculta en los **metadatos EXIF** de la imagen.
    *   *Herramientas recomendadas:* `exiftool` (línea de comandos) o librerías de Python como `piexif` o `Pillow`. Busca en campos como "Artist" o "UserComment".

3.  **Descifrado (Criptografía):**
    *   El texto extraído de los metadatos es una cadena hexadecimal.
    *   Este texto fue cifrado usando una operación **XOR**.
    *   **Clave:** Tu número de carné de estudiante.
    *   **Algoritmo:** `Texto_Cifrado ^ Clave = Texto_Claro`.
    *   Debes implementar un pequeño script para hacer la operación XOR inversa (que es la misma operación) byte por byte.

---

## 🚩 Paso 3: La Flag

Una vez encuentres el archivo `flag.txt`:

1.  **Lectura:**
    *   Abre el archivo. Verás una cadena de caracteres hexadecimales.

2.  **Descifrado:**
    *   Al igual que el Poneglyph, esta flag ha sido cifrada.
    *   **Método:** XOR.
    *   **Clave:** Tu número de carné de estudiante.
    *   Utiliza la misma lógica o script que usaste para el Poneglyph para revelar la flag final.

---

## 🛠️ Pista de Implementación (Python)

Para descifrar XOR en Python, necesitas convertir tus datos (hexadecimal) y tu clave (string) a bytes, y luego iterar:

```python
def xor_decrypt(hex_string, key_string):
    # 1. Convertir el hex_string a bytes
    data_bytes = bytes.fromhex(hex_string)
    
    # 2. Convertir la clave a bytes
    key_bytes = key_string.encode('utf-8')
    
    # 3. Operación XOR byte a byte (repitiendo la clave si es necesaria)
    result = []
    for i in range(len(data_bytes)):
        byte_data = data_bytes[i]
        byte_key = key_bytes[i % len(key_bytes)] # El módulo % permite repetir la clave
        result.append(byte_data ^ byte_key)
        
    # 4. Convertir resultado a string
    return bytes(result).decode('utf-8', errors='ignore')
```
