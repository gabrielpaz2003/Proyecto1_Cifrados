# Proyecto 1 - CTF One Piece de cifrado simetrico

Este repositorio contiene nuestro Proyecto 1 del curso Cifrado de Informacion. La entrega consiste en un CTF tematico de One Piece donde cada reto aplica un metodo de cifrado simetrico distinto y forma una ruta secuencial de resolucion.

## Documento para revision

El documento principal de entrega se encuentra en la carpeta `docs/`.

Para la revision del catedratico, el archivo que debe consultarse es:

```text
docs/proyecto1_reporte.pdf
```

Ese reporte contiene la explicacion formal del proyecto, el diseno de los retos, las decisiones de implementacion y la documentacion de la solucion. El resto del repositorio funciona como material de apoyo, codigo fuente y recursos para reproducir el CTF.

## Descripcion general

El CTF genera una estructura de carpetas tipo laberinto dentro de `challenges/`. En cada reto se debe encontrar un `flag.txt` cifrado y un archivo ZIP con una imagen de poneglyph. Los retos son secuenciales: la flag obtenida en un reto sirve como contrasena para abrir el siguiente.

Orden de resolucion:

1. Luffy - XOR
2. Zoro - RC4
3. Usopp - stream cipher personalizado
4. Nami - ChaCha20

La contrasena inicial para el reto de Luffy es:

```text
onepiece
```

## Estructura del repositorio

```text
.
|-- docs/                         Reporte final, pagina de apoyo e imagenes usadas en la documentacion
|-- resources/                    Recursos para generar imagenes, carpetas, Dockerfiles y contenido del CTF
|-- utils/                        Scripts auxiliares para cifrar, descifrar y extraer informacion
|-- generate_challenges.py        Generador principal de los retos
|-- docker-compose.yml            Configuracion para levantar los contenedores de los retos generados
|-- GUIDE_*.md                    Guias individuales por personaje
|-- GUIA_RESOLUCION_LINUX.md      Guia de resolucion en Linux
|-- flags.txt                     Flags de referencia usadas para validacion
|-- poneglyphs.txt                Texto base usado para los poneglyphs
```

La carpeta `challenges/` no se versiona porque es generada localmente al ejecutar el proyecto.

## Requisitos

Instalar las dependencias de Python:

```bash
pip install -r resources/requirements.txt
```

Dependencias principales:

```text
Pillow
numpy
piexif
pyzipper
pycryptodome
```

## Generacion de retos

Ejecutar:

```bash
python generate_challenges.py
```

El programa solicita el carne del estudiante y genera una version personalizada de los retos en `challenges/`.

## Ejecucion con Docker

Luego de generar los retos, se pueden levantar los contenedores con:

```bash
docker compose up --build
```

Servicios configurados:

```text
luffy_challenge   -> 8081 / 2201
zoro_challenge    -> 8082 / 2202
nami_challenge    -> 8083 / 2203
usopp_challenge   -> 8084 / 2204
```

## Guias y material de apoyo

Las guias por personaje se encuentran en:

```text
GUIDE_LUFFY.md
GUIDE_ZORO.md
GUIDE_USOPP.md
GUIDE_NAMI.md
GUIA_RESOLUCION_LINUX.md
```

Las utilidades para resolver o validar los cifrados estan en `utils/`, incluyendo implementaciones de XOR, RC4, el cifrado personalizado de Usopp, ChaCha20 y extraccion de metadatos EXIF desde las imagenes.

## Nota final

Para efectos de evaluacion, favor tomar como documento principal el reporte ubicado en `docs/proyecto1_reporte.pdf`.
