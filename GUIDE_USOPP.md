# 🤥 Guía de Desafío: Usopp

Usopp es un francotirador ingenioso. Su desafío utiliza un **Cifrado de Flujo Personalizado**.

**⚠️ IMPORTANTE:** Para acceder a este desafío, necesitas haber resuelto el desafío de **Zoro**.

## 🎯 Objetivo

Recuperar:
1.  El texto oculto en el **Poneglyph**.
2.  La **Flag** final del desafío.

---

## 🧭 Paso 1: Búsqueda

Localiza los archivos reales en `challenges/usopp/`. Recuerda que hay señuelos.

---

## 🗿 Paso 2: El Poneglyph

1.  **Descomprimir:**
    *   El archivo zip está protegido con contraseña.
    *   **La contraseña es:** La **FLAG** que obtuviste en el desafío de **Zoro** (formato `FLAG_...`).
2.  **Descifrar Imagen:**
    *   Extrae el EXIF.
    *   Descifra usando **XOR** con tu carné.
    *   Apóyate en `utils/extract_text_from_image.py`.

---

## 🚩 Paso 3: La Flag (Custom Cipher)

El archivo `flag.txt` ha sido cifrado con un algoritmo propio de Usopp.

### ¿Cómo resolverlo?

1.  **Análisis de Código:**
    *   Estudia `utils/usopp_cipher.py`.
    *   La función `encrypt` usa una "semilla" (`seed`) para generar números aleatorios.

2.  **La Semilla (Seed):**
    *   Es una secuencia numérica fija de 4 dígitos: `1234`.

3.  **Ejecución:**
    *   Lee el contenido de `flag.txt` (hex).
    *   Usa la función `usopp_cipher` del script proporcionado.

### Instrucciones para el estudiante:
1.  Importa la función `usopp_cipher` de `utils/usopp_cipher.py`.
2.  Pasa el contenido hexadecimal de la flag.
3.  Pasa la semilla correcta (`1234`).

```python
from utils.usopp_cipher import usopp_cipher

# Asegúrate de revisar si usopp_cipher espera hex string o bytes
# y ajusta tu llamada según corresponda.
flag_content = "..." 
print(usopp_cipher(flag_content, 1234))
```
