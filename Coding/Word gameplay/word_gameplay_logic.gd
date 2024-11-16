extends Control

@export var word_label : WordLabel
@export var letter_button_container : LetterButtonContainer
@export var word_button_container : WordButtonContainer

signal selected_correct_word
signal selected_valid_word

func _ready() -> void:
	letter_button_container.selected_word.connect(verify_word_validity)
	selected_valid_word.connect(shuffle_translation)

#region Handle word label
func _process(delta: float) -> void:
	word_label.set_text(letter_button_container.current_word)
#endregion


#region Shuffle and word button traduction logic
func shuffle_translation(correct_translation) -> void :
	_setup_incorrect_word_buttons( _setup_correct_word_button(Global.word_bank[correct_translation]) )

func _setup_correct_word_button( correct_translation: String ) -> WordButton :
	var correct_word_button : WordButton = word_button_container.get_random_button()
	correct_word_button.selected.connect(_on_correct_word_selected)
	correct_word_button.word = correct_translation
	return correct_word_button

func _setup_incorrect_word_buttons(correct_word_button: WordButton) -> Array :
	var incorrect_word_buttons : Array = word_button_container.randomize_translations([correct_word_button])
	for word_button in incorrect_word_buttons :
		if word_button.selected.is_connected(_on_incorrect_word_selected) == false :
			word_button.selected.connect(_on_incorrect_word_selected.bind(word_button))
	return incorrect_word_buttons
#endregion


#region Check if word is in dictionnary
func verify_word_validity(word:String)  :
	#print("word is | "+word+" | and it's "+str(Global.word_bank.has(word))+" that it is in this dictionnary")
	if Global.word_bank.has(word) == true :
		emit_signal("selected_valid_word",word)
		print("word | " +str(word)+" | exist in word bank array")
	else :
		SignalBus.emit_signal("word_logic_completed")
		print("word | " +str(word)+" | does not exist in word bank array")
#endregion
#region Check if good translation was selected

func _on_incorrect_word_selected( incorrect_button : WordButton ) -> void :
	print("selected incorrect translation")
	SignalBus.emit_signal("word_logic_completed")
	print("------------------------------------------------")

func _on_correct_word_selected() -> void :
	emit_signal("selected_correct_word")
	print("selected correct translation gg")
	SignalBus.emit_signal("word_logic_completed")
	print("------------------------------------------------")
#endregion
