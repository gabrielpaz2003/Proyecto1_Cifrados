import os
import random
import datetime

ARCOS = [
    "East_Blue",
    "Alabasta",
    "Skypiea",
    "Water_7",
    "Sabaody_Archipelago",
    "Fishman_Island",
    "Pirate_Island",
    "Dressrosa",
    "Zou",
    "Wano",
    "Whole_Cake_Island",
]

# Hacer un shuffle the ARCOS
random.seed(datetime.datetime.now().timestamp())
random.shuffle(ARCOS)
ARCOS = ARCOS[:5]

LUGARES_ONEPIECE = {
    "East_Blue": [
        "Romance_Dawn",
        "Shells_Town",
        "Orange_Town",
        "Syrup_Village",
        "Baratie",
        "Arlong_Park",
        "Loguetown",
    ],
    "Alabasta": ["Rainbase", "Yuba", "Nanohana", "Katorea", "Spiders_Cafe", "Alubarna"],
    "Skypiea": [
        "Angel_Beach",
        "Upper_Yard",
        "Shandora",
        "Pumpkin_Cafe",
        "Heavens_Gate",
    ],
    "Water_7": [
        "Blue_Station",
        "Shift_Station",
        "Carpenters_Cafe",
        "GalleyLa_Headquarters",
        "Franky_House",
    ],
    "Sabaody_Archipelago": [
        "Grove_1",
        "Grove_24",
        "Grove_41",
        "Grove_66",
        "Grove_80",
        "Grove_109",
    ],
    "Fishman_Island": [
        "Coral_Hill",
        "Gyoverly_Hills",
        "Mermaid_Cove",
        "Coral_Mansion",
        "Gyoncorde_Plaza",
    ],
    "Pirate_Island": [
        "Pirates_Cove",
        "Pirates_Tavern",
        "Pirates_Hideout",
        "Pirates_Den",
        "Pirates_Ship",
    ],
    "Dressrosa": [
        "Acacia",
        "Corrida_Colosseum",
        "Flower_Hill",
        "Royal_Palace",
        "Toy_House",
    ],
    "Zou": [
        "Right_Belly_Fortress",
        "Left_Belly_Fortress",
        "Right_Hind_Leg",
        "Left_Hind_Leg",
        "Right_Fore_Leg",
        "Left_Fore_Leg",
    ],
    "Wano": ["Kuri", "Udon", "Flower_Capital", "Ringo", "Onigashima"],
    "Whole_Cake_Island": [
        "Sweet_City",
        "Cacao_Island",
        "Caramel_Mountain",
        "Whole_Cake_Chateau",
        "Liqueur_Island",
    ],
}
def limpiar_nombre_casa(nombre):
    return nombre.replace(" ", "_")

CASAS_ONEPIECE_CON_NOMBRES = {
    "Romance_Dawn": [limpiar_nombre_casa(n) for n in ["Casa_de_Makino", "Casa_de_Luffy", "Casa_de_Shanks"]],
    "Shells_Town": [limpiar_nombre_casa(n) for n in ["Casa_de_Rika", "Casa_de_Morgan", "Casa_de_Helmeppo"]],
    "Orange_Town": [limpiar_nombre_casa(n) for n in ["Casa_de_Boodle", "Casa_de_Nami", "Casa_de_Gaimon"]],
    "Syrup_Village": [limpiar_nombre_casa(n) for n in ["Casa_de_Usopp", "Casa_de_Kaya", "Casa_de_Merry"]],
    "Baratie": [limpiar_nombre_casa(n) for n in ["Casa_de_Zeff", "Casa_de_Sanji", "Casa_de_Patty"]],
    "Arlong_Park": [limpiar_nombre_casa(n) for n in ["Casa_de_Arlong", "Casa_de_Nami", "Casa_de_Genzo"]],
    "Loguetown": [limpiar_nombre_casa(n) for n in ["Casa_de_Bell-mère", "Casa_de_Smoker", "Casa_de_Dragon"]],
    "Rainbase": [limpiar_nombre_casa(n) for n in ["Casa_de_Vivi", "Casa_de_Igaram", "Casa_de_Crocodile"]],
    "Yuba": [limpiar_nombre_casa(n) for n in ["Casa_de_Toto", "Casa_de_Kohza", "Casa_de_Pell"]],
    "Nanohana": [limpiar_nombre_casa(n) for n in ["Casa_de_Toto", "Casa_de_Kohza", "Casa_de_Pell"]],
    "Katorea": [limpiar_nombre_casa(n) for n in ["Casa_de_Toto", "Casa_de_Kohza", "Casa_de_Pell"]],
    "Spiders_Cafe": [limpiar_nombre_casa(n) for n in ["Casa_de_Nico Robin", "Casa_de_Miss All Sunday", "Casa_de_Mr. 0"]],
    "Alubarna": [limpiar_nombre_casa(n) for n in ["Casa_de_Vivi", "Casa_de_Igaram", "Casa_de_Crocodile"]],
    "Angel_Beach": [limpiar_nombre_casa(n) for n in ["Casa_de_Conis", "Casa_de_Pagaya", "Casa_de_Gan_Fall"]],
    "Upper_Yard": [limpiar_nombre_casa(n) for n in ["Casa_de_Enel", "Casa_de_Nami", "Casa_de_Aisa"]],
    "Shandora": [limpiar_nombre_casa(n) for n in ["Casa_de_Montblanc Norland", "Casa_de_Calgara", "Casa_de_Robin"]],
    "Pumpkin_Cafe": [limpiar_nombre_casa(n) for n in ["Casa_de_Conis", "Casa_de_Pagaya", "Casa_de_Gan_Fall"]],
    "Heavens_Gate": [limpiar_nombre_casa(n) for n in ["Casa_de_Enel", "Casa_de_Nami", "Casa_de_Aisa"]],
    "Blue_Station": [limpiar_nombre_casa(n) for n in ["Casa_de_Paulie", "Casa_de_Lucci", "Casa_de_Iceburg"]],
    "Shift_Station": [limpiar_nombre_casa(n) for n in ["Casa_de_Paulie", "Casa_de_Lucci", "Casa_de_Iceburg"]],
    "Carpenters_Cafe": [limpiar_nombre_casa(n) for n in ["Casa_de_Paulie", "Casa_de_Lucci", "Casa_de_Iceburg"]],
    "GalleyLa_Headquarters": [limpiar_nombre_casa(n) for n in ["Casa_de_Paulie", "Casa_de_Lucci", "Casa_de_Iceburg"]],
    "Franky_House": [limpiar_nombre_casa(n) for n in ["Casa_de_Franky", "Casa_de_Iceburg", "Casa_de_Luffy"]],
    "Grove_1": [limpiar_nombre_casa(n) for n in ["Casa_de_Rayleigh", "Casa_de_Shakky", "Casa_de_Keimi"]],
    "Grove_24": [limpiar_nombre_casa(n) for n in ["Casa_de_Rayleigh", "Casa_de_Shakky", "Casa_de_Keimi"]],
    "Grove_41": [limpiar_nombre_casa(n) for n in ["Casa_de_Rayleigh", "Casa_de_Shakky", "Casa_de_Keimi"]],
    "Grove_66": [limpiar_nombre_casa(n) for n in ["Casa_de_Rayleigh", "Casa_de_Shakky", "Casa_de_Keimi"]],
    "Grove_80": [limpiar_nombre_casa(n) for n in ["Casa_de_Rayleigh", "Casa_de_Shakky", "Casa_de_Keimi"]],
    "Grove_109": [limpiar_nombre_casa(n) for n in ["Casa_de_Rayleigh", "Casa_de_Shakky", "Casa_de_Keimi"]],
    "Coral_Hill": [limpiar_nombre_casa(n) for n in ["Casa_de_Otohime", "Casa_de_Shirahoshi", "Casa_de_Neptune"]],
    "Gyoverly_Hills": [limpiar_nombre_casa(n) for n in ["Casa_de_Otohime", "Casa_de_Shirahoshi", "Casa_de_Neptune"]],
    "Mermaid_Cove": [limpiar_nombre_casa(n) for n in ["Casa_de_Otohime", "Casa_de_Shirahoshi", "Casa_de_Neptune"]],
    "Coral_Mansion": [limpiar_nombre_casa(n) for n in ["Casa_de_Otohime", "Casa_de_Shirahoshi", "Casa_de_Neptune"]],
    "Gyoncorde_Plaza": [limpiar_nombre_casa(n) for n in ["Casa_de_Otohime", "Casa_de_Shirahoshi", "Casa_de_Neptune"]],
    "Pirates_Cove": [limpiar_nombre_casa(n) for n in ["Casa_de_GolD_Roger", "Casa_de_Whitebeard", "Casa_de_Shanks"]],
    "Pirates_Tavern": [limpiar_nombre_casa(n) for n in ["Casa_de_GolD_Roger", "Casa_de_Whitebeard", "Casa_de_Shanks"]],
    "Pirates_Hideout": [limpiar_nombre_casa(n) for n in [
        "Casa_de_GolD_Roger",
        "Casa_de_Whitebeard",
        "Casa_de_Shanks",
    ]],
    "Pirates_Den": [limpiar_nombre_casa(n) for n in ["Casa_de_Gol_Roger", "Casa_de_Whitebeard", "Casa_de_Shanks"]],
    "Pirates_Ship": [limpiar_nombre_casa(n) for n in ["Casa_de_GolD_Roger", "Casa_de_Whitebeard", "Casa_de_Shanks"]],
    "Acacia": [limpiar_nombre_casa(n) for n in ["Casa_de_Riku_Dold_III", "Casa_de_Viola", "Casa_de_Rebecca"]],
    "Corrida_Colosseum": [limpiar_nombre_casa(n) for n in ["Casa_de_Riku_Dold_III", "Casa_de_Viola", "Casa_de_Rebecca"]],
    "Flower_Hill": [limpiar_nombre_casa(n) for n in ["Casa_de_Riku_Dold_III", "Casa_de_Viola", "Casa_de_Rebecca"]],
    "Royal_Palace": [limpiar_nombre_casa(n) for n in ["Casa_de_Riku_Dold_III", "Casa_de_Viola", "Casa_de_Rebecca"]],
    "Toy_House": [limpiar_nombre_casa(n) for n in ["Casa_de_Sugar", "Casa_de_Trebol", "Casa_de_Doflamingo"]],
    "Right_Belly_Fortress": [limpiar_nombre_casa(n) for n in [
        "Casa_de_Nekomamushi",
        "Casa_de_Inuarashi",
        "Casa_de_Kawamatsu",
    ]],
    "Left_Belly_Fortress": [limpiar_nombre_casa(n) for n in [
        "Casa_de_Nekomamushi",
        "Casa_de_Inuarashi",
        "Casa_de_Kawamatsu",
    ]],
    "Right_Hind_Leg": [limpiar_nombre_casa(n) for n in ["Casa_de_Nekomamushi", "Casa_de_Inuarashi", "Casa_de_Kawamatsu"]],
    "Left_Hind_Leg": [limpiar_nombre_casa(n) for n in ["Casa_de_Nekomamushi", "Casa_de_Inuarashi", "Casa_de_Kawamatsu"]],
    "Right_Fore_Leg": [limpiar_nombre_casa(n) for n in ["Casa_de_Nekomamushi", "Casa_de_Inuarashi", "Casa_de_Kawamatsu"]],
    "Left_Fore_Leg": [limpiar_nombre_casa(n) for n in ["Casa_de_Nekomamushi", "Casa_de_Inuarashi", "Casa_de_Kawamatsu"]],
    "Kuri": [limpiar_nombre_casa(n) for n in ["Casa_de_Oden", "Casa_de_Kozuki_Hiyori", "Casa_de_Kozuki_Momonosuke"]],
    "Udon": [limpiar_nombre_casa(n) for n in ["Casa_de_Oden", "Casa_de_Kozuki_Hiyori", "Casa_de_Kozuki_Momonosuke"]],
    "Flower_Capital": [limpiar_nombre_casa(n) for n in [
        "Casa_de_Oden",
        "Casa_de_Kozuki_Hiyori",
        "Casa_de_Kozuki_Momonosuke",
    ]],
    "Ringo": [limpiar_nombre_casa(n) for n in ["Casa_de_Oden", "Casa_de_Kozuki_Hiyori", "Casa_de_Kozuki_Momonosuke"]],
    "Onigashima": [limpiar_nombre_casa(n) for n in ["Casa_de_Kaido", "Casa_de_Orochi", "Casa_de_Yamato"]],
    "Sweet_City": [limpiar_nombre_casa(n) for n in ["Casa_de_Big_Mom", "Casa_de_Pudding", "Casa_de_Katakuri"]],
    "Cacao_Island": [limpiar_nombre_casa(n) for n in ["Casa_de_Big_Mom", "Casa_de_Pudding", "Casa_de_Katakuri"]],
    "Caramel_Mountain": [limpiar_nombre_casa(n) for n in ["Casa_de_Big_Mom", "Casa_de_Pudding", "Casa_de_Katakuri"]],
    "Whole_Cake_Chateau": [limpiar_nombre_casa(n) for n in ["Casa_de_Big_Mom", "Casa_de_Pudding", "Casa_de_Katakuri"]],
    "Liqueur_Island": [limpiar_nombre_casa(n) for n in ["Casa_de_Big_Mom", "Casa_de_Pudding", "Casa_de_Katakuri"]],
}

ACTIVIDADES_RANDOM = [
    "Has encontrado un tesoro que apunta a {lugar}",
    "Has encontrado una pista que apunta a {lugar}",
    "Has encontrado un mapa que apunta a {lugar}",
    "Has encontrado un lugar lleno de secretos y misterios que apuntan a {lugar}",
    "Te cansaste de buscar y te has quedado dormido",
    "Has encontrado un enemigo y ha tenido que huir",
    "Has encontrado un amigo y han decidido viajar juntos",
    "Has encontrado un obstáculo y hay que superarlo",
    "Has encontrado un objeto misterioso y no sabes qué es",
    "Has encontrado un enemigo y ha tenido que luchar",
    "Has encontrado un lugar seguro",
    "Has encontrado un lugar peligroso",
    "Has encontrado un lugar misterioso",
    "Has encontrado un lugar abandonado",
]


# Función para crear el laberinto de carpetas
def generar_laberinto(ruta_base):
    carpetas_creadas = []

    for x in ARCOS:
        ruta_arco = os.path.join(ruta_base, x)
        if not os.path.exists(ruta_arco):
            os.mkdir(ruta_arco)
        for lugar in LUGARES_ONEPIECE[x]:
            ruta_lugar = os.path.join(ruta_arco, lugar)
            if not os.path.exists(ruta_lugar):
                os.mkdir(ruta_lugar)
            for casa in CASAS_ONEPIECE_CON_NOMBRES[lugar]:
                ruta_actual_casa = os.path.join(ruta_lugar, casa)
                if not os.path.exists(ruta_actual_casa):
                    os.mkdir(ruta_actual_casa)
                carpetas_creadas.append(ruta_actual_casa)

    return carpetas_creadas


def crear_archivos_con_ruta(carpetas, challenge):
    # Obtener 2 rutas aleatorias
    ruta_aleatoria_1 = random.choice(carpetas)
    lugar1 = ruta_aleatoria_1.split("/")[-2]
    casa1 = ruta_aleatoria_1.split("/")[-1]
    ruta_aleatoria_2 = random.choice(carpetas)
    # get 10 random carpetas
    random_carpetas = random.sample(carpetas, 10)

    for carpeta in random_carpetas:
        if carpeta == ruta_aleatoria_1 or carpeta == ruta_aleatoria_2:
            continue

        ruta_flag = os.path.join(carpeta, "flag.txt")
        index = 0
        with open(ruta_flag, "w") as archivo:
            actividad = random.choice(ACTIVIDADES_RANDOM)
            if index == 0:
                actividad = actividad.replace("{lugar}", lugar1)
                index = 1
            else:
                actividad = actividad.replace("{lugar}", casa1)
                index = 0

            archivo.write(actividad)

    return ruta_aleatoria_1, ruta_aleatoria_2


# Directorio base del laberinto
def main(challenge):
    # Eliminar el laberinto si ya existe
    if os.path.exists(f"challenges/{challenge}/ONEPIECE"):
        os.system("rm -r " + f"challenges/{challenge}/ONEPIECE")

    # Directorio para el reto
    challenge_dir = f"challenges/{challenge}/ONEPIECE"
    # Crear directorio si no existe
    os.makedirs(challenge_dir, exist_ok=True)

    carpetas = generar_laberinto(challenge_dir)
    ruta1, ruta2 = crear_archivos_con_ruta(carpetas, challenge)
    print("Laberinto generado con éxito.")
    return ruta1, ruta2, carpetas


if __name__ == "__main__":
    main()
