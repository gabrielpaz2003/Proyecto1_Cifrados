# Dockerfiles
docker_files = {
    "luffy": "resources/dockerfiles/luffy/Dockerfile",
    "zoro": "resources/dockerfiles/zoro/Dockerfile",
    "usopp": "resources/dockerfiles/usopp/Dockerfile",
    "sanji": "resources/dockerfiles/sanji/Dockerfile",
    "nami": "resources/dockerfiles/nami/Dockerfile",
    "robin": "resources/dockerfiles/robin/Dockerfile",
}


# Copia el archivo Dockerfile a la carpeta del reto
def create_docker_file(challenge, password):
    with open(docker_files[challenge], "r") as file:
        content = file.read()

    with open(f"challenges/{challenge}/Dockerfile", "w") as file:
        linea = f'RUN useradd -ms /bin/bash {challenge} && echo "{challenge}:{password}" | chpasswd && adduser {challenge} sudo'
        content = content.replace(f"RUN useradd -ms /bin/bash user_challenge", linea)
        file.write(content)
