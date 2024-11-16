extends TextureButton
class_name LetterButton

@export var letter_label : Label
@export var _animation : AnimationPlayer

var is_selected : bool = false
var letter : String = ""

signal selected
signal unselected

func _ready() -> void :
	pressed.connect( clicked )
	choose_letter()
func choose_letter() -> void :
	letter_label.text = Global.choose_random_letter()
	letter = letter_label.text
#region Clicking logic

func clicked() -> void :
	if is_selected == true :
		unselect()
	elif is_selected == false :
		select()

func select() -> void :
	is_selected = true
	_animation.play("selected")
	emit_signal("selected")
func unselect() -> void :
	is_selected = false
	_animation.play("unselected")
	emit_signal("unselected")

func delete() -> void :
	modulate = Color(1, 1, 1, 0)
	disabled = true
	letter_label.queue_free()
	_animation.queue_free()
 
#endregion
