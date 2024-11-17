extends Control
class_name ScoreLogic

var score = 0
var high_score = 0


@export var score_label : Label

func _process(delta: float) -> void:
	_update_score_label(score)

func _word_based_add_points ( word : String ) -> void :
	match word.length() :
		3 :
			_add_points(5)
		4 :
			_add_points(10)
		5 :
			_add_points(20)

func _update_score_label ( new_score : float ) -> void :
	score_label.text = str(roundi(score))

func _add_points ( number_of_points : float ) -> void :
	score = score + number_of_points
