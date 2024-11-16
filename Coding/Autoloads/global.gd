extends Node


#region Values for probabilities
var letter_probabilities = {
	"E": 12, "A": 12, "O": 9, "S": 7, "R": 7, "N": 6, "I": 6, "D": 5,
	"L": 5, "C": 4, "T": 4, "U": 4, "M": 3, "P": 3, "B": 2, "G": 2,
	"V": 1, "Y": 1, "Q": 1, "H": 1, "F": 1, "J": 0.5, "Z": 0.5, "X": 0.2,
	"K": 0.1, "W": 0.1
}

var word_bank = {
	"mano": "main", "gato": "chat", "viento": "vent", "agua": "eau", "flor": "fleur",
	"cielo": "ciel", "tren": "train", "mesa": "table", "luna": "lune", "sol": "soleil",
	"vaca": "vache", "nino": "enfant", "rojo": "rouge", "gente": "gens", "puerta": "porte",
	"lago": "lac", "piedra": "pierre", "pan": "pain", "campo": "champ", "casa": "maison",
	"razón": "raison", "amor": "amour", "carro": "voiture", "tierra": "terre", "animal": "animal",
	"luz": "lumière", "nieve": "neige", "silla": "chaise", "papel": "papier", "puente": "pont",
	"plaza": "place", "noche": "nuit", "lucha": "lutte", "mujer": "femme", "perro": "chien",
	"pueblo": "village", "árbol": "arbre", "vino": "vin", "baño": "salle de bain", "calle": "rue",
	"plato": "assiette", "rio": "rivière", "arte": "art", "reina": "reine", "tiempo": "temps",
	"camino": "chemin", "sangre": "sang", "torre": "tour", "mes": "mois", "fruta": "fruit",
	"miel": "miel", "oro": "or", "diente": "dent", "ojo": "œil", "pie": "pied", "ropa": "vêtements",
	"piel": "peau", "grano": "grain", "mar": "mer", "rata": "rat", "sal": "sel", "té": "thé",
	"fuego": "feu", "paz": "paix", "rey": "roi", "carne": "viande", "rosa": "rose",
	"lobo": "loup","vida": "vie", "hombre": "homme", "ave": "oiseau", "hierba": "herbe",
	"verde": "vert", "cabra": "chèvre", "coche": "auto", "tigre": "tigre",
	"huevo": "œuf", "raton": "souris", "pluma": "plume", "colina": "colline", 
	"hoja": "feuille", "leche": "lait", "playa": "plage", "nina": "fille", "color": "couleur", "boca": "bouche", 
	"espalda": "dos", "deseo": "souhait","libro": "livre", 
	"salud": "santé", "amigo": "ami", "corazon": "cœur", "mundo": "monde",
	"padre": "père", "hermano": "frère", "historia": "histoire", "alma": "âme",
	"mente": "esprit", "dios": "dieu", "pecado": "péché", "madre": "mère",
	"corona": "couronne", "llama": "embrasement", "heroe": "héros", "silencio": "calme", 
	"espejo": "miroir", "ciudad": "métropole", "montana": "mont",
	"lluvia": "averse","ojos": "yeux", "risa": "éclat","azucar": "sucre",
	"estrella": "étoile","planta": "herbe", "esfera": "globule", "i" : "correct", "e" : "correct", "a" : "correct"
}

var _total_probabilities = 0.0
#endregion

func _ready() -> void:
#region Setting up probabilities
	for letter in letter_probabilities.keys() :
		_total_probabilities = _total_probabilities + letter_probabilities [letter]
	for letter in letter_probabilities.keys():
		letter_probabilities [letter] = letter_probabilities [letter] / _total_probabilities  
#endregion

#region Choose random letter

func choose_random_letter() -> String:

	var random_value = randf()
	var cumulative_probability = 0.0

	for letter in letter_probabilities.keys():
		cumulative_probability += letter_probabilities[letter]
		if random_value < cumulative_probability :
			return letter
	return letter_probabilities.keys().back()
#endregion
#region Choose random word
func choose_random_word() -> Dictionary:
	var keys = word_bank.keys()  # Get all the keys in the dictionary
	var random_index = int(randf() * keys.size())  # Generate a random index
	var chosen_word = keys[random_index]  # Select a random key
	var translation = word_bank[chosen_word]  # Get the translation
	return {chosen_word: translation} 
#endregion
