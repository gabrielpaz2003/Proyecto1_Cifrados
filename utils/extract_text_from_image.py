#!/usr/bin/env python3
"""
Script para extraer y descifrar texto de imágenes poneglyph en los desafíos CTF.

Este script:
1. Descomprime archivos ZIP con contraseña (archivos .dat, .zip, etc.)
2. Extrae el texto cifrado de los metadatos EXIF de la imagen
3. Descifra el texto usando XOR con el carné del estudiante

Uso:
    python extract_text_from_image.py <ruta_al_archivo> <carné>
    
Ejemplo:
    python extract_text_from_image.py data_546a2d997058.zip 12345
"""

import sys
import os
from PIL import Image
import piexif
import pyzipper
import tempfile
import shutil

# Agregar el directorio padre al path para importar utils
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
try:
    from utils.luffy_xor import xor_cipher
except ImportError:
    # Si se ejecuta desde utils/
    try:
        from luffy_xor import xor_cipher
    except ImportError:
        print("❌ Error: No se pudo importar luffy_xor.py")
        sys.exit(1)


def unzip_file_with_password(file_path, password="onepiece", extract_to=None):
    """
    Descomprime un archivo ZIP protegido con contraseña.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"El archivo no existe: {file_path}")
    
    if extract_to is None:
        extract_to = os.path.dirname(file_path)
    
    extracted_files = []
    
    try:
        # Intentar con pyzipper.ZipFile (cifrado tradicional)
        with pyzipper.ZipFile(file_path, 'r') as zip_ref:
            zip_ref.setpassword(password.encode())
            zip_ref.extractall(extract_to)
            extracted_files = zip_ref.namelist()
            print(f"✅ Archivo descomprimido exitosamente")
    except Exception as e:
        # Si falla, intentar con AESZipFile por si acaso
        try:
            with pyzipper.AESZipFile(file_path, 'r') as zip_ref:
                zip_ref.setpassword(password.encode())
                zip_ref.extractall(extract_to)
                extracted_files = zip_ref.namelist()
                print(f"✅ Archivo descomprimido exitosamente (AES)")
        except Exception as e2:
            raise Exception(f"Error al descomprimir: {e}. Intento AES: {e2}")
    
    return extracted_files


def extract_text_from_exif(image_path):
    """
    Extrae el texto almacenado en los metadatos EXIF de una imagen.
    """
    if not os.path.exists(image_path):
        raise FileNotFoundError(f"La imagen no existe: {image_path}")
    
    try:
        img = Image.open(image_path)
        exif_data = img.info.get('exif', b'')
        
        if not exif_data:
            print("⚠️  La imagen no tiene metadatos EXIF")
            return None
        
        exif_dict = piexif.load(exif_data)
        texto_bytes = exif_dict['0th'].get(piexif.ImageIFD.Artist)
        
        if texto_bytes:
            texto = texto_bytes.decode('utf-8')
            print(f"✅ Texto extraído de los metadatos EXIF")
            return texto
        else:
            print("⚠️  No se encontró texto en los metadatos EXIF")
            return None
            
    except Exception as e:
        raise Exception(f"Error al extraer texto de la imagen: {e}")


def decrypt_text(ciphertext, student_id):
    """
    Descifra el texto usando XOR con el carné del estudiante.
    """
    if isinstance(ciphertext, str):
        try:
            ciphertext_bytes = bytes.fromhex(ciphertext)
        except ValueError:
            ciphertext_bytes = ciphertext.encode('utf-8')
    else:
        ciphertext_bytes = ciphertext
    
    decrypted_bytes = xor_cipher(ciphertext_bytes, student_id)
    
    try:
        return decrypted_bytes.decode('utf-8')
    except UnicodeDecodeError:
        return decrypted_bytes.hex()


def extract_and_decrypt(file_path, student_id, password="onepiece", cleanup=True):
    print("=" * 60)
    print("🔍 EXTRACCIÓN Y DESCIFRADO DE PONEGLYPH")
    print("=" * 60)
    print(f"📁 Archivo: {file_path}")
    
    extract_dir = os.path.join(os.path.dirname(file_path), ".temp_extract")
    os.makedirs(extract_dir, exist_ok=True)
    
    try:
        print("\n📦 Paso 1: Descomprimiendo archivo ZIP...")
        extracted_files = unzip_file_with_password(file_path, password, extract_dir)
        
        image_file = None
        for file in extracted_files:
            full_path = os.path.join(extract_dir, file)
            if file.lower().endswith(('.jpeg', '.jpg', '.png')):
                image_file = full_path
                break
        
        if not image_file:
            # Buscar cualquier imagen en el directorio
            for root, dirs, files in os.walk(extract_dir):
                for file in files:
                    if file.lower().endswith(('.jpeg', '.jpg', '.png')):
                        image_file = os.path.join(root, file)
                        break
        
        if not image_file:
            raise Exception("No se encontró ninguna imagen en el archivo ZIP")
        
        print(f"✅ Imagen encontrada: {os.path.basename(image_file)}")
        
        print("\n📝 Paso 2: Extrayendo texto de metadatos EXIF...")
        ciphertext = extract_text_from_exif(image_file)
        
        if not ciphertext:
            raise Exception("No se pudo extraer texto")
        
        print("\n🔓 Paso 3: Descifrando texto con XOR...")
        decrypted_text = decrypt_text(ciphertext, student_id)
        
        print("\n" + "=" * 60)
        print("✅ RESULTADO")
        print("=" * 60)
        print(f"\n📜 Texto descifrado:\n{decrypted_text}\n")
        
        return decrypted_text
        
    finally:
        if cleanup and os.path.exists(extract_dir):
            shutil.rmtree(extract_dir)



location = 'challenges/luffy/ONEPIECE/East_Blue/Arlong_Park/Casa_de_Nami/data_380daff4d196.zip'
student_id = '1234'
password = 'onepiece'

# unzip_file_with_password(location, password)
# extracted = extract_text_from_exif("challenges/luffy/ONEPIECE/East_Blue/Arlong_Park/Casa_de_Nami/poneglyph.jpeg")
# print(extracted)
# print(decrypt_text(extracted, student_id))

# # extract_and_decrypt(location, student_id, password)

print(decrypt_text("777e72736e050b555001500005050004090b0556540552555007510054535756060a005209", student_id))