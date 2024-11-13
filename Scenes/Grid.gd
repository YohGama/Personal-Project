extends Control


@export var _Buttons : Array[LetterButton] = []
var SelectedButtons : Array[LetterButton] = []
var SelectedButtonsLetters : Array = []

func _ready() -> void :
	for Buttons in _Buttons :
		Buttons._selected.connect(_on_letterbutton_selected.bind(Buttons))
		Buttons._unselected.connect(_on_letterbutton_unselected.bind(Buttons))

func _process(delta):
	print(SelectedButtonsLetters)
	if SelectedButtonsLetters.size() >= 5 :
		for Buttons in SelectedButtons :
			Buttons.unselect()
		SelectedButtons.clear()
		SelectedButtonsLetters.clear()

func _on_letterbutton_selected(letterButton : LetterButton):
	if SelectedButtons.has(letterButton) == false :
		SelectedButtons.append(letterButton)
		SelectedButtonsLetters.append(letterButton.letter)

func _on_letterbutton_unselected(letterButton : LetterButton):
	if SelectedButtons.has(letterButton) == true :
		SelectedButtons.erase(letterButton)
		SelectedButtonsLetters.erase(letterButton.letter)
