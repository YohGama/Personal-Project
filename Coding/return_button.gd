extends TextureButton

@export var _animator : AnimationPlayer

func _ready() -> void:
	button_down.connect(_clicked)

func _clicked() -> void :
	_animator.play("clicked")
	SceneManager.change_scene("Circle",SceneManager.MAIN_MENU,true,true)
