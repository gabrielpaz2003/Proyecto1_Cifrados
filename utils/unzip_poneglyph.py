#!/usr/bin/env python3
"""
Script simple para descomprimir archivos ZIP protegidos con contraseña.
"""

import sys
import pyzipper
import os

if len(sys.argv) < 2:
    print("Uso: python unzip_poneglyph.py <archivo.zip> [contraseña]")
    print("Ejemplo: python unzip_poneglyph.py data_xxxxx.zip")
    sys.exit(1)

zip_path = sys.argv[1]
password = sys.argv[2] if len(sys.argv) > 2 else "onepiece"

if not os.path.exists(zip_path):
    print(f"❌ Error: El archivo '{zip_path}' no existe")
    sys.exit(1)

try:
    print(f"📦 Descomprimiendo: {zip_path}")
    print(f"🔑 Contraseña: {password}")
    
    with pyzipper.AESZipFile(zip_path, 'r') as zf:
        zf.setpassword(password.encode())
        zf.extractall(os.path.dirname(zip_path) or ".")
        
        print("✅ Archivo descomprimido exitosamente")
        print(f"📁 Archivos extraídos:")
        for name in zf.namelist():
            print(f"   - {name}")
            
except Exception as e:
    print(f"❌ Error al descomprimir: {e}")
    print("\nPosibles causas:")
    print("  1. La contraseña es incorrecta")
    print("  2. El archivo está corrupto")
    print("  3. El archivo no es un ZIP válido")
    sys.exit(1)
