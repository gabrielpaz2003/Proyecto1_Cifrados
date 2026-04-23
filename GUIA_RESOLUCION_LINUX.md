# Guia de resolucion Linux/WSL - Proyecto 1 Cifrados de Flujo

Esta guia esta pensada para resolver el proyecto desde Ubuntu/WSL usando comandos reproducibles. La idea no es quemar flags, sino encontrar los archivos, extraer los datos cifrados, aplicar el algoritmo correcto y documentar evidencia.

## 1. Preparar terminal y entorno

Abre una terminal **Ubuntu (WSL)** desde VS Code y entra al repo:

```bash
cd "$(wslpath -u 'C:\Gabriel\UVG\9 SEMESTRE\CIFRADO DE INFORMACIÓN\Proyecto1\ctf_onepice_symmetric_cipher')"
pwd
```

Instala herramientas de linea de comandos. `7z` sirve para ZIP normales y ZIP AES creados desde Windows.

```bash
sudo apt update
sudo apt install -y python3 python3-pip python3-venv zip unzip p7zip-full libimage-exiftool-perl xxd perl
```

Crea un ambiente Python solo para ejecutar el generador del proyecto y las partes que dependen exactamente de las utilidades del repo.

```bash
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r resources/requirements.txt
```

Define tu carne una sola vez. Cambia el valor antes de ejecutar:

```bash
export CARNE="TU_CARNE_AQUI"
```

Genera los retos. Cuando el script pregunte por el carne, escribe el mismo valor de `CARNE`.

```bash
python generate_challenges.py
```

Levanta los contenedores Docker para cumplir con la metodologia del proyecto:

```bash
docker compose up -d --build
docker ps
```

Para evidencia, puedes entrar a cada contenedor asi:

```bash
docker exec -it -u luffy luffy_challenge bash
docker exec -it -u zoro zoro_challenge bash
docker exec -it -u usopp usopp_challenge bash
docker exec -it -u nami nami_challenge bash
```

Nota: los comandos criptograficos de esta guia estan pensados para ejecutarse desde la raiz del repo en WSL, porque ahi tienes todos los archivos y herramientas juntas. En las capturas puedes mostrar tambien que los contenedores estan corriendo.

## 2. Crear archivos de entrega

Ejecuta esto una vez al inicio de la resolucion:

```bash
: > flags.txt
: > poneglyphs.txt
mkdir -p work
```

## 3. Pegar funciones auxiliares en Bash

Estas funciones encuentran archivos reales y descifran datos. Pegalas completas en la terminal WSL despues de definir `CARNE`.

```bash
find_real_flag () {
  local challenge="$1"
  find "challenges/$challenge" -type f -name "flag.txt" -exec sh -c '
    for f do
      content=$(tr -d "\r\n" < "$f")
      if printf "%s" "$content" | grep -Eq "^[0-9a-fA-F]+$"; then
        printf "%s\n" "$f"
      fi
    done
  ' sh {} +
}

xor_hex () {
  local hex="$1" key="$2"
  printf "%s" "$hex" | xxd -r -p | perl -Mbytes -e '
    my $key = shift;
    my @key = map { ord } split //, $key;
    binmode STDIN; binmode STDOUT;
    my $i = 0;
    while (read STDIN, my $b, 1) {
      print chr(ord($b) ^ $key[$i++ % @key]);
    }
  ' "$key"
}

rc4_hex () {
  local hex="$1" key="$2"
  printf "%s" "$hex" | xxd -r -p | perl -Mbytes -e '
    my $key = shift;
    my @key = map { ord } split //, $key;
    my @S = 0..255;
    my $j = 0;
    for my $i (0..255) {
      $j = ($j + $S[$i] + $key[$i % @key]) % 256;
      @S[$i, $j] = @S[$j, $i];
    }
    my ($i, $jj) = (0, 0);
    binmode STDIN; binmode STDOUT;
    while (read STDIN, my $c, 1) {
      $i = ($i + 1) % 256;
      $jj = ($jj + $S[$i]) % 256;
      @S[$i, $jj] = @S[$jj, $i];
      my $k = $S[($S[$i] + $S[$jj]) % 256];
      print chr(ord($c) ^ $k);
    }
  ' "$key"
}

find_real_zip () {
  local challenge="$1" pass="$2"
  local found=""
  while IFS= read -r z; do
    local d img artist
    d=$(mktemp -d "work/${challenge}_zip_XXXXXX")
    if 7z x -p"$pass" -y -o"$d" "$z" >/dev/null 2>&1; then
      img=$(find "$d" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | head -n 1)
      if [ -n "$img" ]; then
        artist=$(exiftool -s -s -s -Artist "$img" 2>/dev/null | tr -d "\r\n")
        if printf "%s" "$artist" | grep -Eq "^[0-9a-fA-F]+$"; then
          found="$z"
          printf "%s\n" "$found"
          return 0
        fi
      fi
    fi
  done < <(find "challenges/$challenge" -type f -name "data_*.zip")
  return 1
}

decrypt_poneglyph () {
  local challenge="$1" pass="$2"
  local z d img artist plain
  z=$(find_real_zip "$challenge" "$pass") || return 1
  d=$(mktemp -d "work/${challenge}_real_XXXXXX")
  7z x -p"$pass" -y -o"$d" "$z" >/dev/null
  img=$(find "$d" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | head -n 1)
  artist=$(exiftool -s -s -s -Artist "$img" | tr -d "\r\n")
  plain=$(xor_hex "$artist" "$CARNE")
  printf "%s\n" "$plain"
}
```

## 4. Reto Luffy - XOR

La contrasena inicial del ZIP es `onepiece`.

```bash
LUFFY_FLAG_FILE=$(find_real_flag luffy)
echo "$LUFFY_FLAG_FILE"

LUFFY_HEX=$(tr -d "\r\n" < "$LUFFY_FLAG_FILE")
LUFFY_FLAG=$(xor_hex "$LUFFY_HEX" "$CARNE")
echo "$LUFFY_FLAG"

LUFFY_PONEGLYPH=$(decrypt_poneglyph luffy "onepiece")
echo "$LUFFY_PONEGLYPH"

printf "Luffy: %s\n" "$LUFFY_FLAG" | tee -a flags.txt
printf "Luffy: %s\n\n" "$LUFFY_PONEGLYPH" | tee -a poneglyphs.txt
```

Evidencia recomendada:

```bash
find challenges/luffy -type f \( -name "flag.txt" -o -name "data_*.zip" \)
echo "$LUFFY_FLAG"
echo "$LUFFY_PONEGLYPH"
```

Explicacion tecnica: XOR combina cada byte del texto cifrado con el byte correspondiente de la clave. Como XOR es reversible, aplicar XOR otra vez con el mismo carne recupera el texto original.

## 5. Reto Zoro - RC4

La contrasena del ZIP de Zoro es la flag de Luffy.

```bash
ZORO_FLAG_FILE=$(find_real_flag zoro)
echo "$ZORO_FLAG_FILE"

ZORO_HEX=$(tr -d "\r\n" < "$ZORO_FLAG_FILE")
ZORO_FLAG=$(rc4_hex "$ZORO_HEX" "$CARNE")
echo "$ZORO_FLAG"

ZORO_PONEGLYPH=$(decrypt_poneglyph zoro "$LUFFY_FLAG")
echo "$ZORO_PONEGLYPH"

printf "Zoro: %s\n" "$ZORO_FLAG" | tee -a flags.txt
printf "Zoro: %s\n\n" "$ZORO_PONEGLYPH" | tee -a poneglyphs.txt
```

Evidencia recomendada:

```bash
find challenges/zoro -type f \( -name "flag.txt" -o -name "data_*.zip" \)
echo "$ZORO_FLAG"
echo "$ZORO_PONEGLYPH"
```

Explicacion tecnica: RC4 genera un flujo de clave con KSA y PRGA. Ese flujo se combina con XOR contra el texto cifrado. La clave usada por el reto es el carne.

## 6. Reto Usopp - cifrado de flujo custom

La contrasena del ZIP de Usopp es la flag de Zoro. El cifrado custom usa el generador pseudoaleatorio de Python con semilla `1234`, por eso aqui se usa un comando Python minimo y reproducible. No contiene la flag quemada, solo implementa el algoritmo del reto.

```bash
USOPP_FLAG_FILE=$(find_real_flag usopp)
echo "$USOPP_FLAG_FILE"

USOPP_HEX=$(tr -d "\r\n" < "$USOPP_FLAG_FILE")
USOPP_FLAG=$(
python3 - "$USOPP_HEX" <<'PY'
import random
import sys

cipher = bytes.fromhex(sys.argv[1])
random.seed(1234)
keystream = bytes(random.randint(0, 255) for _ in range(len(cipher)))
plain = bytes(c ^ k for c, k in zip(cipher, keystream))
print(plain.decode())
PY
)
echo "$USOPP_FLAG"

USOPP_PONEGLYPH=$(decrypt_poneglyph usopp "$ZORO_FLAG")
echo "$USOPP_PONEGLYPH"

printf "Usopp: %s\n" "$USOPP_FLAG" | tee -a flags.txt
printf "Usopp: %s\n\n" "$USOPP_PONEGLYPH" | tee -a poneglyphs.txt
```

Evidencia recomendada:

```bash
find challenges/usopp -type f \( -name "flag.txt" -o -name "data_*.zip" \)
echo "$USOPP_FLAG"
echo "$USOPP_PONEGLYPH"
```

Explicacion tecnica: el algoritmo crea un keystream debil con `random.seed(1234)` y `randint(0, 255)`. Al ser un cifrado de flujo, se recupera el texto aplicando XOR entre ciphertext y keystream.

## 7. Reto Nami - ChaCha20

La contrasena del ZIP de Nami es la flag de Usopp. ChaCha20 usa una clave de 32 bytes y un nonce de 8 bytes derivados del carne, exactamente como `utils/nami_chacha.py`.

```bash
NAMI_FLAG_FILE=$(find_real_flag nami)
echo "$NAMI_FLAG_FILE"

NAMI_HEX=$(tr -d "\r\n" < "$NAMI_FLAG_FILE")
NAMI_FLAG=$(
python3 - "$NAMI_HEX" "$CARNE" <<'PY'
import sys
from Crypto.Cipher import ChaCha20

cipher = bytes.fromhex(sys.argv[1])
student_id = sys.argv[2]
key = (student_id.encode() * 32)[:32]
nonce = (student_id.encode() * 8)[:8]
plain = ChaCha20.new(key=key, nonce=nonce).decrypt(cipher)
print(plain.decode())
PY
)
echo "$NAMI_FLAG"

NAMI_PONEGLYPH=$(decrypt_poneglyph nami "$USOPP_FLAG")
echo "$NAMI_PONEGLYPH"

printf "Nami: %s\n" "$NAMI_FLAG" | tee -a flags.txt
printf "Nami: %s\n\n" "$NAMI_PONEGLYPH" | tee -a poneglyphs.txt
```

Evidencia recomendada:

```bash
find challenges/nami -type f \( -name "flag.txt" -o -name "data_*.zip" \)
echo "$NAMI_FLAG"
echo "$NAMI_PONEGLYPH"
```

Explicacion tecnica: ChaCha20 tambien es un cifrado de flujo, pero moderno. El reto deriva la clave y el nonce repitiendo el carne hasta alcanzar 32 y 8 bytes respectivamente.

## 8. Verificar entregables

Al final revisa que los archivos tengan todo:

```bash
echo "FLAGS"
cat flags.txt

echo "PONEGLYPHS"
cat poneglyphs.txt

ls -lh flags.txt poneglyphs.txt
```

Para convertir el reporte terminado a PDF, abre `proyecto1_reporte_template.docx`, llenalo con tus capturas y datos, luego exportalo como `proyecto1_reporte.pdf` desde Word o LibreOffice.

## 9. Capturas que conviene pegar en el reporte

1. Terminal con `python generate_challenges.py`.
2. Terminal con `docker compose up -d --build` y `docker ps`.
3. Por cada reto: busqueda del `flag.txt` real y del `data_*.zip`.
4. Por cada reto: salida con flag descifrada.
5. Por cada reto: salida con texto del poneglyph descifrado.
6. Captura final de `cat flags.txt` y `cat poneglyphs.txt`.
7. Captura final de los archivos de entrega con `ls -lh`.

## 10. Validacion opcional

El generador deja marcadores ocultos `.marker_238` en las carpetas correctas. Puedes usarlos solo para validar que encontraste la ruta correcta, pero en el reporte es mejor explicar la busqueda por contenido hexadecimal y metadatos EXIF.

```bash
find challenges -name ".marker_238" -print
```
