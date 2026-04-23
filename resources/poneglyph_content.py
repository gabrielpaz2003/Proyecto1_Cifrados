the_demons_of_ohara = [
    "The researchers on Ohara decided to study their island's Poneglyph in an attempt to discover the missing history of the world.",
    "However, they were limited by lack of access to and knowledge of the other Poneglyphs, and thus sent out researchers to find more information on them, knowing the study of the Poneglyphs was illegal.",
    "Nico Olvia, along with thirty-three other archaeologists, set out to sea. Sadly, their attempt failed, and they were intercepted by the Marines, leaving Olvia as the sole survivor. ",
    "The Marines found information among the belongings of the dead researchers that allowed them to trace the team back to Ohara, and a CP9 unit was sent to investigate.",
    "The World Government had always been wary of the archaeologists because of their knowledge, but researching the Poneglyphs meant they had an excuse to act against them.",
    "Olvia escaped the Marines with the help of Jaguar D. Saul[52] and managed to return to Ohara in time to warn her comrades about the Marines heading their way. However, CP9 had already arrived on the island[51] and a Buster Call attack commenced after Clou D. Clover revealed that he had discovered the knowledge held by the Poneglyph in the Tree of Knowledge.[53] Ohara was destroyed, wiping out the entire island and all of its inhabitants with the exception of Nico Robin, who managed to flee in the process, leaving the fate of the Ohara Poneglyph a mystery.",
]
arabasta_arc = [
    "Crocodile targeted the Arabasta Kingdom because of its Poneglyph, which contained information on the whereabouts of Pluton, ",
    "and created the Baroque Works syndicate in an attempt to bring down the Arabasta Kingdom and claim Pluton, employing Robin to read the Poneglyph",
    "When Robin finally got the chance to read this Poneglyph, however, she lied about its contents, which caused Crocodile to turn against her because he no longer needed her",
    "Due to the ferocious battle between Monkey D. Luffy and Crocodile, compounded by an attempt from King Nefertari Cobra to crush Crocodile underneath the rubble by displacing a pillar,",
    "the Tomb of the Kings where the Poneglyph was held became unstable and began collapsing around them.",
    "Luffy saved Robin and Cobra, but the Poneglyph was buried in the collapse.[12]",
]
skypiea_arc = [
    "Robin joined the Straw Hat Pirates, claiming Luffy was responsible for her continued existence,",
    "and traveled with them to Skypiea where another Poneglyph was held. There was a wall in the Shandorian ruins cryptically describing",
    "the location of the Poneglyph in the same runes that the Poneglyphs themselves were inscribed with.",
    "The Poneglyph itself, located at the base of the Golden Belfry, contained details about Poseidon and a message written by Roger, ",
    "telling further researchers to keep going forward. According to Gan Fall, he had no idea when or how Roger managed to reach the Poneglyph on top of Giant Jack.",
    "Robin informed the Shandia that their duty to protect the stone was over, freeing them from their ancestors' burden.",
]
sabaody = [
    "At the Sabaody Archipelago, Roger's first mate, Silvers Rayleigh, mentioned to Robin during the Straw Hats' meeting with him that",
    "he knows what the Void Century is and that Roger solved the mysteries of the Poneglyphs;",
    "however, he also admitted that saying what it was would take away the impact or any",
    "further interpretations of the lost history, due to his crew not being proper historians like the Ohara archaeologists,",
    "before telling Robin to search out the Poneglyphs and draw her own conclusions regarding the lost history.",
    "Despite this, Rayleigh offered Robin the chance to hear the information from him, but she declined his offer and chose to continue to pursue the Poneglyphs herself.",
]
fish_man = [
    "By the time the Straw Hat Pirates arrived at Fish-Man Island, its Road Poneglyph had been removed.",
    "After arriving at the Sea Forest, Robin read the lone Poneglyph there and",
    "discovered that it was engraved with an apology letter from a man known as Joy Boy to Poseidon.",
    "Upon Neptune learning she was a survivor of the Ohara Incident and could read Poneglyphs,",
    "he told Robin the story handed down through ",
    "the Ryugu Kingdom royal family regarding Joy Boy.",
]
zou_arc = [
    "When Jack and the Beasts Pirates invaded Zou to look for Raizo of Wano Country,",
    "the Mink Tribe chained him to the Road Poneglyph within the Whale Tree to keep him from showing himself.",
    "Seventeen days later, the Straw Hats, Trafalgar Law, and Raizo's samurai comrades freed him from the Poneglyph.",
    "When Robin noted its red color, Duke Inuarashi explained that it had a different purpose than the normal blue Poneglyphs did and gave her permission to read it.",
    "After Robin deciphered the Road Poneglyph, Inuarashi explained its purpose of revealing the location of Laugh Tale when its information was combined with that of the other three Road Poneglyphs.",
    "Cobra and his daughter Nefertari Vivi left Arabasta to attend Levely.[60] Despite his ill health, Cobra wished to attend because he planned to ask the World Government about Poneglyphs, a desire he has held ever since his encounter with Robin.",
]


def get_challenges_texts(random_number=None):
    if random_number == 0:
        return the_demons_of_ohara
    elif random_number == 1:
        return arabasta_arc
    elif random_number == 2:
        return skypiea_arc
    elif random_number == 3:
        return sabaody
    elif random_number == 4:
        return fish_man
    elif random_number == 5:
        return zou_arc
    else:
        return the_demons_of_ohara
    
def get_texts(random_number):
    texts_list = get_challenges_texts(random_number)
    # Definir los textos para los retos
    texts = {
        "luffy": texts_list[0],
        "zoro": texts_list[1],
        "usopp": texts_list[2],
        "sanji": texts_list[3],
        "nami": texts_list[4],
        "robin": texts_list[5],
    }
    return texts