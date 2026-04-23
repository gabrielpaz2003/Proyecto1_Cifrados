# Usamos una imagen base de Ubuntu
FROM ubuntu:22.04

# Evitar interactividad en la instalación de paquetes
# ARG DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    sudo \
    python3 \
    python3-pip \
    python3-dev \
    git \
    vim \
    nano \
    curl \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

# Crear un usuario "sanji" y darle una contraseña
RUN useradd -ms /bin/bash user_challenge

# Deshabilitamos el acceso directo como root para que los alumnos no inicien con permisos de administrador
RUN passwd -l root

# Establecer el directorio de trabajo
WORKDIR /home/sanji

# Copiar los archivos del reto dentro del contenedor
COPY ./ONEPIECE /home/sanji/ONEPIECE

# Cambiar la propiedad de los archivos al usuario sanji
RUN chown -R sanji:sanji /home/sanji

# Cambiar al usuario "sanji" por defecto
USER nobody

EXPOSE 8000 
# Script de inicio
CMD ["bash"]