extends TextureButton


@export var word_label : Label
@export var _animation : AnimationPlayer

var is_selected : bool = false
var word : String = ""

func _ready() -> void :
	pressed.connect( clicked )

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
