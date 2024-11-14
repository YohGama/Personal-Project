extends Node


var letter_probabilities = {
	"E": 12, "A": 12, "O": 9, "S": 7, "R": 7, "N": 6, "I": 6, "D": 5,
	"L": 5, "C": 4, "T": 4, "U": 4, "M": 3, "P": 3, "B": 2, "G": 2,
	"V": 1, "Y": 1, "Q": 1, "H": 1, "F": 1, "J": 0.5, "Z": 0.5, "X": 0.2,
	"K": 0.1, "W": 0.1
}

var _total_probabilities = 0.0

func _ready() -> void:

	for letter in letter_probabilities.keys() :
		_total_probabilities = _total_probabilities + letter_probabilities [letter]
	for letter in letter_probabilities.keys():
		letter_probabilities [letter] = letter_probabilities [letter] / _total_probabilities  




func choose_random_letter() -> String:

	var random_value = randf()
	var cumulative_probability = 0.0

	for letter in letter_probabilities.keys():
		cumulative_probability += letter_probabilities[letter]
		if random_value < cumulative_probability :
			return letter
	return letter_probabilities.keys().back()
