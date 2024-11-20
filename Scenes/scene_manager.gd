extends Control

const GAMEPLAY_SCENE = "res://Scenes/Gameplay.tscn"

var _current_scene = null
var _main_scene = null

@export var _frontground : ColorRect
@export var _animator : AnimationPlayer

func change_scene( _animation_name, _new_scene, _transition_in, _transition_out ) -> void :
	if _transition_in == true :
		_animation_transition(_animation_name,true)
	await _change_scene(_current_scene,_new_scene)
	if _transition_out == true :
		_animation_transition(_animation_name,false)

func _change_scene (_old_scene,_new_scene) -> void :
	if _old_scene != null :
		_old_scene.queue_free()
	var created_scene = load(_new_scene).instantiate()
	_current_scene = created_scene
	_main_scene.add_child(created_scene)

func _animation_transition ( _animation_name,_play_animation_frontwards ) -> void :
	if _play_animation_frontwards == true :
		_animator.play( _animation_name )
	if _play_animation_frontwards == false :
		_animator.play_backwards( _animation_name )
