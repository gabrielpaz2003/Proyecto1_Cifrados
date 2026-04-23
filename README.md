# CTF One Piece - Symmetric Cipher

Este proyecto es un CTF (Capture The Flag) temático de One Piece enfocado en criptografía simétrica. Cada desafío representa a un miembro de la tripulación y utiliza un método de cifrado diferente.

## 🏴‍☠️ Instrucciones Generales

1.  **Generar los desafíos:**
    Ejecuta el script `generate_challenges.py` e ingresa tu carné de estudiante. Esto creará una estructura de directorios única para ti.
    ```bash
    python generate_challenges.py
    ```

2.  **Explorar el mapa:**
    Dentro de la carpeta `challenges/`, encontrarás subcarpetas para cada personaje (Luffy, Zoro, Usopp, Nami). Dentro de cada una, hay un "laberinto" de carpetas con nombres de lugares de One Piece.

3.  **Secuencia de Juego:**
    **¡IMPORTANTE!** Los desafíos son secuenciales. La **FLAG** que encuentres en un desafío te servirá como **contraseña** para desbloquear el archivo ZIP del siguiente desafío.
    
    Orden de resolución:
    1.  **Luffy** (Contraseña inicial: `onepiece`)
    2.  **Zoro** (Contraseña: Flag de Luffy)
    3.  **Usopp** (Contraseña: Flag de Zoro)
    4.  **Nami** (Contraseña: Flag de Usopp)

## 🧩 Herramientas de Ayuda

En la carpeta `utils/` encontrarás scripts que te ayudarán a resolver los retos.
-   `extract_text_from_image.py`: Utilidad para extraer y descifrar el texto oculto en los poneglyphs.
-   Scripts de cifrado específicos por personaje (`luffy_xor.py`, `zoro_rc4.py`, etc.).

---

## 🍖 Desafío 1: Monkey D. Luffy (XOR)

Luffy es directo, al igual que su cifrado.

### Pasos:
1.  **Buscar:** Encuentra el archivo `flag.txt` y el archivo zip del Poneglyph en `challenges/luffy/`.
2.  **Poneglyph:**
    -   Contraseña ZIP: `onepiece`.
    -   Extrae la imagen y obtén el texto oculto en los metadatos EXIF.
    -   Descifra con **XOR** usando tu carné.
3.  **Flag:**
    -   Descifra el `flag.txt` usando **XOR** con tu carné.
    -   **Guarda esta flag**, la necesitarás para el siguiente reto.

## ⚔️ Desafío 2: Roronoa Zoro (RC4)

Zoro usa sus espadas en un flujo continuo.

### Pasos:
1.  **Buscar:** Localiza los archivos en `challenges/zoro/`.
2.  **Poneglyph:**
    -   Contraseña ZIP: **Flag de Luffy**.
    -   Descifra el texto de la imagen con XOR (carné).
3.  **Flag:**
    -   Descifra `flag.txt` con **RC4**.
    -   Clave: Tu **carné**.
    -   Revisa `utils/zoro_rc4.py`.

## 🤥 Desafío 3: Usopp (Stream Cipher Custom)

Usopp cuenta historias que a veces hay que descifrar.

### Pasos:
1.  **Buscar:** Localiza los archivos en `challenges/usopp/`.
2.  **Poneglyph:**
    -   Contraseña ZIP: **Flag de Zoro**.
    -   Descifra el texto de la imagen con XOR (carné).
3.  **Flag:**
    -   Descifra `flag.txt` con el cifrado custom de Usopp.
    -   Semilla: `1234`.
    -   Revisa `utils/usopp_cipher.py`.

## 💰 Desafío 4: Nami (ChaCha20)

Nami es sofisticada y moderna.

### Pasos:
1.  **Buscar:** Localiza los archivos en `challenges/nami/`.
2.  **Poneglyph:**
    -   Contraseña ZIP: **Flag de Usopp**.
    -   Descifra el texto de la imagen con XOR (carné).
3.  **Flag:**
    -   Descifra `flag.txt` con **ChaCha20**.
    -   Clave y Nonce derivados de tu **carné**.
    -   Revisa `utils/nami_chacha.py`.

---

## ⚠️ Notas Importantes

-   **Archivos Falsos:** Hay imágenes que dicen "Este poneglyph no es el que buscas". Ignóralas.
-   **Librerías:** Asegúrate de instalar las dependencias:
    ```bash
    pip install -r resources/requirements.txt
    ```
