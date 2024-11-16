extends HBoxContainer
class_name WordButtonContainer

var word_buttons : Array[WordButton] = []

func _ready() -> void:
	SignalBus.word_logic_completed.connect(_on_word_logic_completed)
	for button in get_children() :
		if button is WordButton :
			word_buttons.append(button)

func randomize_translations( exclude : Array[WordButton] = [null] ) :
	var _word_buttons = word_buttons.duplicate(true)
	for excluded in exclude :
		if _word_buttons.has(excluded) == true :
			_word_buttons.erase(excluded)
	for button in _word_buttons :
		button.word = Global.choose_random_word().values()[0]
	return _word_buttons
func get_random_button() :
	var _button = randi() % get_children().size()
	return get_children()[_button]

func _on_word_logic_completed() -> void :
	for button in word_buttons :
		button.word = ""
		if button.is_selected == true :
			button.unselect()
