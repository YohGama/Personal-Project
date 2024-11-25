extends Node



var letter_probabilities = {
	"E": 12, "A": 12, "O": 9, "S": 7, "R": 7, "N": 6, "I": 6, "D": 5,
	"L": 5, "C": 4, "T": 4, "U": 4, "M": 3, "P": 3, "B": 2, "G": 2,
	"V": 1, "Y": 1, "Q": 1, "H": 1, "F": 1, "J": 0.5, "Z": 0.5, "X": 0.2,
	"K": 0.1, "W": 0.1
}

var word_bank = {
	"mano": "main", "gato": "chat", "agua": "eau", "flor": "fleur", "cielo": "ciel", 
	"tren": "train", "mesa": "table", "luna": "lune", "sol": "soleil", "vaca": "vache", 
	"nino": "enfant", "rojo": "rouge", "gente": "gens", "lago": "lac", "pan": "pain", 
	"campo": "champ", "casa": "maison", "razón": "raison", "amor": "amour", "carro": "voiture", 
	"luz": "lumière", "nieve": "neige", "silla": "chaise", "papel": "papier", "plaza": "place", 
	"noche": "nuit", "lucha": "lutte", "mujer": "femme", "perro": "chien", "árbol": "arbre", 
	"vino": "vin", "baño": "salle de bain", "calle": "rue", "plato": "assiette", "rio": "rivière", 
	"arte": "art", "reina": "reine", "torre": "tour", "mes": "mois", "fruta": "fruit", "miel": "miel", 
	"oro": "or", "ojo": "œil", "pie": "pied", "ropa": "vêtements", "piel": "peau", "grano": "grain", 
	"mar": "mer", "rata": "rat", "sal": "sel", "fuego": "feu", "paz": "paix", "rey": "roi", "carne": "viande", 
	"rosa": "rose", "lobo": "loup", "vida": "vie", "ave": "oiseau", "verde": "vert", "cabra": "chèvre", 
	"coche": "auto", "tigre": "tigre", "huevo": "œuf", "raton": "souris", "pluma": "plume", "hoja": "feuille", 
	"leche": "lait", "playa": "plage", "nina": "fille", "color": "couleur", "boca": "bouche", "deseo": "souhait", 
	"libro": "livre", "salud": "santé", "amigo": "ami", "mundo": "monde", "padre": "père", "alma": "âme", 
	"mente": "esprit", "dios": "dieu", "madre": "mère", "llama": "embrasement", "heroe": "héros", "ojos": "yeux", 
	"risa": "éclat", "fresa": "fraise", "dulce": "bonbon", "hojas": "feuilles", "frio": "froid", "pasto": "gazon", 
	"pulpo": "poulpe", "salto": "saut", "mango": "mangue", "gusto": "goût", "marea": "marée", "brisa": "brise", 
	"vacas": "vaches", "bomba": "bombe", "reloj": "montre", "cinta": "ruban", "tabla": "planche", "brote": "bourgeon", 
	"aroma": "arôme", "barro": "boue", "lento": "lent", "patio": "cour", "puño": "poing", "feliz": "heureux", 
	"claro": "clair", "negro": "noir", "largo": "long", "ancho": "large", "pobre": "pauvre", "sucio": "sale", 
	"rico": "riche", "joven": "jeune", "nuevo": "nouveau", "viejo": "vieux", "tonto": "bête", "sabio": "sage", 
	"calor": "chaud", "denso": "dense", "suave": "doux", "lindo": "joli", "raro": "rare", "vivo": "vivant", 
	"seco": "sec", "fiel": "loyal", "comer": "manger", "beber": "boire", "vivir": "vivre", "leer": "lire", 
	"escribir": "écrire", "correr": "courir", "saltar": "sauter", "hablar": "parler", 
	"trabajar": "travailler", "jugar": "jouer", "cantar": "chanter", "bailar": "danser", 
	"ver": "voir", "oír": "entendre", "escuchar": "écouter", "pensar": "penser", 
	"caminar": "marcher", "nadar": "nager", "cocinar": "cuisiner", 
	"ayudar": "aider", "comprar": "acheter", "vender": "vendre", "estudiar": "étudier", 
	"entrar": "entrer", "salir": "sortir", "llegar": "arriver", "dejar": "laisser",
	"morir": "mourir", "llorar": "pleurer", "reír": "rire","nanguy":"bête",

}


var _total_probabilities = 0.0



func _ready() -> void:

	for letter in letter_probabilities.keys() :
		_total_probabilities = _total_probabilities + letter_probabilities [letter]
	for letter in letter_probabilities.keys():
		letter_probabilities [letter] = letter_probabilities [letter] / _total_probabilities  

func split_string ( array : Array, number_of_rows : int ) -> Array :
	var rows = []
	for i in range ( 0, array.size(), number_of_rows ) :
		rows.append ( array.slice (i, i + number_of_rows) )
	return rows
func choose_random_letter() -> String:

	var random_value = randf()
	var cumulative_probability = 0.0

	for letter in letter_probabilities.keys():
		cumulative_probability += letter_probabilities[letter]
		if random_value < cumulative_probability :
			return letter
	return letter_probabilities.keys().back()
func choose_random_word() -> Dictionary:
	var keys = word_bank.keys()  # Get all the keys in the dictionary
	var random_index = int(randf() * keys.size())  # Generate a random index
	var chosen_word = keys[random_index]  # Select a random key
	var translation = word_bank[chosen_word]  # Get the translation
	return {chosen_word: translation} 

func disconnect_all_signals(node: Object) -> void:
	var signals = node.get_signal_list()
	for _signal in signals :
		var connections = node.get_signal_connection_list(_signal)
		for connection in connections:
			node.disconnect(_signal, connection["target"])
