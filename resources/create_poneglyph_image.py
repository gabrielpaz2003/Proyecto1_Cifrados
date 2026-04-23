import os
import numpy as numpy
from PIL import Image, ImageDraw
import piexif
import pyzipper
import hashlib
import random

# Obtener el directorio base del proyecto (un nivel arriba de resources/)
script_dir = os.path.dirname(os.path.abspath(__file__))
project_dir = os.path.dirname(script_dir)

# Definir las imágenes "poneglyphs"
poneglyphs = {
    "luffy": os.path.join(project_dir, "resources/poneglyphs/luffy.jpeg"),
    "zoro": os.path.join(project_dir, "resources/poneglyphs/zoro.jpeg"),
    "usopp": os.path.join(project_dir, "resources/poneglyphs/usopp.jpeg"),
    "sanji": os.path.join(project_dir, "resources/poneglyphs/sanji.jpeg"),
    "nami": os.path.join(project_dir, "resources/poneglyphs/nami.jpeg"),
    "robin": os.path.join(project_dir, "resources/poneglyphs/robin.jpeg"),
}

# Definir las imágenes fake
fake_poneglyphs = [
    os.path.join(project_dir, "resources/poneglyphs/fake_1.jpeg"),
    os.path.join(project_dir, "resources/poneglyphs/fake_2.jpeg"),
    os.path.join(project_dir, "resources/poneglyphs/fake_3.jpeg"),
    os.path.join(project_dir, "resources/poneglyphs/fake_4.jpeg"),
]

# Todos los archivos usan extensión .zip
DECOY_EXTENSIONS = [".zip"]

# Función para crear un ZIP con contraseña
# Usa comando zip del sistema para máxima compatibilidad con unzip
def zip_with_password(zip_path, file_path, password):
    if os.name == 'nt':
        # En Windows usamos pyzipper (puede requerir 7z para abrir si es AES)
        with pyzipper.AESZipFile(zip_path, 'w', compression=pyzipper.ZIP_DEFLATED, encryption=pyzipper.WZ_AES) as zf:
            zf.setpassword(password.encode())
            zf.write(file_path, os.path.basename(file_path))
    else:
        # En Linux/Mac usamos el comando zip del sistema para cifrado tradicional
        # Esto asegura que 'unzip -P password' funcione correctamente
        # -j: junk paths (no guardar estructura de directorios)
        # -P: password
        import subprocess
        try:
            cmd = ['zip', '-P', password, '-j', zip_path, file_path]
            subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        except (subprocess.CalledProcessError, FileNotFoundError):
            # Fallback a pyzipper con AES si zip no está instalado
            print(f"⚠️  Advertencia: comando 'zip' no encontrado. Usando AES (requerirá unzip compatible).")
            with pyzipper.AESZipFile(zip_path, 'w', compression=pyzipper.ZIP_DEFLATED, encryption=pyzipper.WZ_AES) as zf:
                zf.setpassword(password.encode())
                zf.write(file_path, os.path.basename(file_path))

# Función para crear un ZIP falso con imagen fake
def create_fake_zip(zip_path, password, challenge):
    # Seleccionar una imagen fake aleatoria
    fake_image_path = random.choice(fake_poneglyphs)
    
    # Verificar que el archivo existe
    if not os.path.exists(fake_image_path):
        raise FileNotFoundError(f"Imagen fake no encontrada: {fake_image_path}")
    
    # Abrir la imagen fake (debe ser JPEG válido)
    try:
        img = Image.open(fake_image_path)
        # Verificar que es JPEG
        if img.format != 'JPEG':
            raise ValueError(f"La imagen fake debe ser JPEG, pero es {img.format}: {fake_image_path}")
    except Exception as e:
        raise ValueError(f"Error al abrir imagen fake {fake_image_path}: {e}. Asegúrate de que sea un JPEG válido.")
    
    # Convertir a RGB si tiene canal alpha o es un formato diferente
    if img.mode != 'RGB':
        img = img.convert('RGB')
    
    d = ImageDraw.Draw(img)
    
    # Agregar el mensaje de que no es el poneglyph correcto
    fake_message = "Este poneglyph no es el que buscas"
    d.text((10, 10), fake_message, fill=(255, 255, 0))
    
    # Verificar si la imagen tiene EXIF
    exif_data = img.info.get("exif")
    
    if exif_data:
        exif_dict = piexif.load(exif_data)
    else:
        exif_dict = piexif.load(piexif.dump({}))
    
    # Agregar el mensaje como metadato EXIF también
    exif_dict["0th"][piexif.ImageIFD.Artist] = fake_message.encode("utf-8")
    exif_bytes = piexif.dump(exif_dict)
    
    # Guardar la imagen temporal con el mensaje
    temp_image = f"{zip_path}.tmp.jpeg"
    img.save(temp_image, exif=exif_bytes)
    
    try:
        # Usar pyzipper para crear el zip con contraseña (funciona en Windows y Unix)
        zip_with_password(zip_path, temp_image, password)
    finally:
        if os.path.exists(temp_image):
            os.remove(temp_image)


# Función para crear imágenes "poneglyph"
def create_poneglyph_image(text, challenge, password, location, carpetas_laberinto=None, folder_identifier="238"):
    # Abrir la imagen de la lista de "poneglyphs"
    img = Image.open(poneglyphs[challenge])
    d = ImageDraw.Draw(img)

    # Agregar texto visible en la imagen (mostrar solo una parte para no saturar)
    # El texto completo estará en los metadatos EXIF
    display_text = text[:50] + "..." if len(text) > 50 else text
    d.text((10, 10), f"Cifrado: {display_text}", fill=(255, 255, 0))

    # Verificar si la imagen tiene EXIF
    exif_data = img.info.get("exif")

    if exif_data:
        exif_dict = piexif.load(exif_data)
    else:
        # Si no hay EXIF, inicializamos un diccionario vacío
        exif_dict = piexif.load(piexif.dump({}))

    # Agregar el texto como metadato EXIF (campo Artist o UserComment)
    exif_dict["0th"][piexif.ImageIFD.Artist] = text.encode(
        "utf-8"
    )  # Usando 'Artist' para almacenar el texto

    # Convertir los metadatos a formato EXIF
    exif_bytes = piexif.dump(exif_dict)

    # Guardar la imagen con el texto visible y los metadatos
    image_path = f"challenges/{challenge}/poneglyph.jpeg"
    img.save(image_path, exif=exif_bytes)
    
    # Crear archivo marcador con identificador en la carpeta de la imagen
    marker_file = os.path.join(location, f".marker_{folder_identifier}")
    with open(marker_file, "w") as marker:
        marker.write(f"Challenge: {challenge}\n")
        marker.write(f"Image location: {location}\n")
        marker.write(f"Password: {password}\n")
    
    # Generar un nombre aleatorio para el archivo real basado en hash
    # Usar challenge + location + password para generar un hash único pero determinístico
    hash_input = f"{challenge}_{location}_{password}"
    file_hash = hashlib.md5(hash_input.encode()).hexdigest()[:12]
    # Usar extensión .zip para compatibilidad con unzip estándar
    real_filename = f"data_{file_hash}.zip"
    real_zip_path = f"{location}/{real_filename}"
    
    # Crear el archivo ZIP real con nombre aleatorio
    # Usar pyzipper para crear el zip con contraseña (funciona en Windows y Unix)
    zip_with_password(real_zip_path, image_path, password)
    
    # Eliminar la imagen original
    if os.path.exists(image_path):
        os.remove(image_path)
    
    # Crear archivos ZIP falsos en otras ubicaciones del laberinto
    if carpetas_laberinto and len(carpetas_laberinto) > 1:
        # Seleccionar entre 5-10 carpetas aleatorias para crear archivos falsos
        num_fake_files = min(random.randint(5, 10), len(carpetas_laberinto) - 1)
        fake_locations = random.sample(
            [c for c in carpetas_laberinto if c != location], 
            num_fake_files
        )
        
        for fake_location in fake_locations:
            # Generar nombre aleatorio basado en hash (similar al archivo real)
            # Todos los archivos usan extensión .zip
            fake_hash_input = f"{challenge}_{fake_location}_{password}_{random.randint(1000, 9999)}"
            fake_file_hash = hashlib.md5(fake_hash_input.encode()).hexdigest()[:12]
            fake_filename = f"data_{fake_file_hash}.zip"
            fake_zip_path = f"{fake_location}/{fake_filename}"
            
            # Crear archivo ZIP falso con imagen fake
            create_fake_zip(fake_zip_path, password, challenge)
