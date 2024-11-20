extends Control

@export var word_logic : WordLogic
@export var score_logic : ScoreLogic

func _ready() -> void:
	word_logic.selected_correct_word.connect(score_logic._word_based_add_points)
