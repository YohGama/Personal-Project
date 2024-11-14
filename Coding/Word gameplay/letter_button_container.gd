extends Control
class_name LetterButtonContainer

@export var grid_buttons : Array[LetterButton] = []
var selected_buttons : Array[LetterButton] = []
var selected_letters : Array = []

signal _finished_unselecting
signal _selected_word ( word : String )

func _ready() -> void :

	for button_node in grid_buttons :
		button_node.selected.connect(_on_letter_button_selected.bind(button_node))
		button_node.unselected.connect(_on_letter_button_unselected.bind(button_node))

func _process(delta) -> void :

	if selected_buttons.size() >= 5 :
		await get_tree().create_timer(0.5).timeout
		for button in selected_buttons :
			button.unselect()
		emit_signal("_finished_unselecting")
		selected_buttons.clear()
		selected_letters.clear()

func _on_letter_button_selected ( button : LetterButton ) -> void:

	if selected_buttons.has(button) == false :
		selected_buttons.append(button)
		selected_letters.append(button.letter)


func _on_letter_button_unselected ( button : LetterButton ) -> void :

	if selected_buttons.has(button) == true :
		await _finished_unselecting
		selected_buttons.erase(button)
		selected_letters.erase(button.letter)
