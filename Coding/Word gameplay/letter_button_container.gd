extends Control
class_name LetterButtonContainer

@export var grid_buttons : Array[LetterButton] = []
var grid_letters : Array = []
var selected_buttons : Array[LetterButton] = []
var selected_letters : Array = []
var current_word : String = ""

var banned_words : Array = []
var _visited_tiles : Array = []
var _neighbors = [-1, 0, 1]
var trie : Dictionary = {}

@export var maximum_word_length : int
@export var minimum_word_length : int

signal _finished_unselecting
signal selected_word ( word : String )

func _ready() -> void :
	SignalBus.word_logic_completed.connect(_on_word_logic_completed)
	_initialize_buttons(grid_buttons)
	_update_grid_letters()
	build_trie()
	check_dead_grids()
	#reset_banned_letters()

		
func _process(delta) -> void :
	_update_grid_letters()
	_update_current_word(selected_letters)
	_recognize_words()

func _on_word_logic_completed(word,found) -> void :
	if found == true :
		for button in selected_buttons :
			button.is_used = true
	#if found == true :
		#ban_used_letters(current_word)
	if found == true :
		banned_words.append(word)
	for button in selected_buttons :
		_unselect(button)
	emit_signal("_finished_unselecting")
	selected_buttons.clear()
	selected_letters.clear()
	find_words()


#region Algorthym

func find_words() -> Array:

	var found_words = []
	_update_grid_letters()
	_initialize_visited_tiles()

	for x in range(0,5):
		for y in range(0,5):
			search_word(x,y,"",found_words)

	for word in banned_words :
		if banned_words.has(word) :
			found_words.erase(word)

	print(banned_words)
	print(found_words)
	return found_words
func search_word(x, y, _current_word: String, found_words: Array) -> void:


	var grid_width = grid_letters.size()
	var grid_height = grid_letters[0].size()

	if x < 0 or x >= grid_width or y < 0 or y >= grid_height or _visited_tiles[x][y] : return
	#if banned_letters.has(grid_letters[x][y].to_lower()) == true : return
	_current_word += grid_letters[x][y].to_lower()

	if _current_word.length() > 6 : return
	if is_valid_prefix(_current_word) == false : return
	if is_word(_current_word) == true and found_words.has(_current_word)== false : found_words.append(_current_word)

	_visited_tiles[x][y] = true
	for dx in [-1, 0, 1] :
		for dy in [-1, 0, 1] :
			if not ( dx == 0 and dy == 0 ) :
				search_word ( x + dx, y + dy, _current_word, found_words )
	_visited_tiles[x][y] = false

func build_trie() -> void :
	for word in Global.word_bank :
		add_to_trie(word)
func add_to_trie(word: String) -> void:
	var current = trie
	for letter in word:
		if not current.has(letter):
			current[letter] = {}
		current = current[letter]
	current["END"] = true
func is_word(word: String) -> bool:
	var current = trie
	for letter in word:
		if not current.has(letter):
			return false
		current = current[letter]
	return current.has("END")
func is_valid_prefix(prefix: String) -> bool :
	var current = trie
	for letter in prefix :
		if not current.has(letter):
			return false
		current = current[letter]
	return true
func _initialize_visited_tiles() -> void :
	_visited_tiles.clear()
	for i in range(6):
		_visited_tiles.append([false, false, false, false, false,false])
func check_dead_grids() -> void :
	while find_words().size() < 15 :
		_initialize_buttons(grid_buttons)
		_update_grid_letters()
#func ban_used_letters(word: String) -> void:
	#for letter in word:
		#if not banned_letters.has(letter):
			#banned_letters.append(letter)
#func reset_banned_letters() -> void:
	#banned_letters.clear()
#endregion
#region Selected button array logic
func _initialize_buttons (button_array : Array[LetterButton]) :
	for button_node in button_array :
		button_node.choose_letter()
		if button_node.selected.is_connected(_on_letter_button_selected.bind(button_node)) == false and button_node.unselected.is_connected(_on_letter_button_unselected.bind(button_node)) == false :
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
		button.unselect()
#endregion
#region Word recognition
func _recognize_words ():
	if _is_word_long_enough(selected_buttons,minimum_word_length,maximum_word_length) == false : return
	if already_used_word(selected_buttons) == false : return
	if banned_words.has(current_word) == true : return
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
func _update_grid_letters() -> void :
	grid_letters = []
	for button in grid_buttons :
		grid_letters.append(button.letter)
	grid_letters = Global.split_string(grid_letters,6)
func already_used_word(buttons: Array[LetterButton]) -> bool:
	for button in buttons:
		if not button.is_used:  # Check if any value is NOT true
			return true
	return false  # If no `false` values were found, all are true
#endregion
