extends TextureButton
class_name WordButton

@export var word_label : Label
@export var _animation : AnimationPlayer

var is_selected : bool = false
var word : String = ""

signal selected
signal unselected

func _ready() -> void :
	pressed.connect( clicked )

func _process(delta: float):
	_update_word_label(word)

func _update_word_label(new_word) :
	word_label.text = word

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
#endregion
