extends Control
class_name LetterButtonContainer

@export var grid_buttons : Array[LetterButton] = []
var selected_buttons : Array[LetterButton] = []
var selected_letters : Array = []
var current_word : String = ""

@export var maximum_word_length : int
@export var minimum_word_length : int

signal _finished_unselecting
signal selected_word ( word : String )

func _ready() -> void :
	SignalBus.word_logic_completed.connect(_on_word_logic_completed)
	_init_buttons(grid_buttons)

func _process(delta) -> void :
	_update_current_word(selected_letters)
	_recognize_words()


#region Selected button array logic
func _init_buttons (button_array : Array[LetterButton]) :
	for button_node in button_array :
		button_node.selected.connect(_on_letter_button_selected.bind(button_node))
		button_node.unselected.connect(_on_letter_button_unselected.bind(button_node))
func _on_letter_button_selected ( button : LetterButton ) -> void:
	if selected_buttons.has(button) == false :
		selected_buttons.append(button)
		selected_letters.append(button.letter)
func _on_letter_button_unselected ( button : LetterButton ) -> void :
	if selected_buttons.has(button) == true :
		selected_buttons.erase(button)
		selected_letters.erase(button.letter)
func _unselect ( button : LetterButton ) -> void :
	if selected_buttons.has(button) == true :
		await _finished_unselecting
		selected_buttons.erase(button)
		selected_letters.erase(button.letter)
#endregion

func _on_word_logic_completed() -> void :
	for button_node in selected_buttons :
		button_node.delete()
	selected_buttons.clear()
	selected_letters.clear()

func _recognize_words ():
	if _is_word_long_enough(selected_buttons,minimum_word_length,maximum_word_length) == false : return
	if Input.is_action_just_pressed("ui_left") :
		emit_signal("selected_word",current_word)
		print("string of letter | "+str(current_word)+" | recognized as word")
		await SignalBus.word_logic_completed
func _is_word_long_enough ( array : Array, minimum_size : int, maximum_size : int ) -> bool :
	if ( array.size() <= maximum_size and array.size() >= minimum_size ) :
		return true
	else : return false
func _update_current_word( letter_array : Array ):
	current_word = ""
	for letter in letter_array :
		current_word += letter
	current_word = current_word.to_lower()
