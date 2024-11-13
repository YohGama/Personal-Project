extends Node


# Define a dictionary where keys are letters and values are probabilities
var letter_probabilities = {
	"E": 12, "A": 12, "O": 9, "S": 7, "R": 7, "N": 6, "I": 6, "D": 5,
	"L": 5, "C": 4, "T": 4, "U": 4, "M": 3, "P": 3, "B": 2, "G": 2,
	"V": 1, "Y": 1, "Q": 1, "H": 1, "F": 1, "J": 0.5, "Z": 0.5, "X": 0.2,
	"K": 0.1, "W": 0.1
}

var total_prob = 0.0  # sum of all probabilities

func _ready() -> void:

	for letter in letter_probabilities.keys() :
		total_prob += letter_probabilities[letter]
	for letter in letter_probabilities.keys():
		letter_probabilities[letter] /= total_prob  




func choose_random_letter() -> String:

# scale each probability to sum to 1

	var random_value = randf()  # Generate a random number between 0 and 1
	var cumulative_probability = 0.0
	# Loop through each letter and its probability in the dictionary
	for letter in letter_probabilities.keys():
		cumulative_probability += letter_probabilities[letter]
		if random_value < cumulative_probability :

			return letter

	# Default case (should not hit this if probabilities sum to 1)
	return letter_probabilities.keys().back()
