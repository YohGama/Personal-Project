extends TextureButton
class_name LetterButton

@export var letterLabel : Label
@export var animation : AnimationPlayer

var selected : bool = false
var letter : String = ""

signal _selected
signal _unselected

func _ready() -> void:
	self.pressed.connect( clicked )
	chooseLetter_()

func chooseLetter_() -> void:
	letterLabel.text = Global.choose_random_letter()
	letter = letterLabel.text

func clicked() -> void :
	if selected == true :
		unselect()
	elif selected == false :
		select()

func select() -> void :
	selected = true
	animation.play("Selected")
	emit_signal("_selected")
func unselect() -> void :
	selected = false
	animation.play("Unselected")
	emit_signal("_unselected")
