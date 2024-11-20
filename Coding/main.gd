extends Control

func _ready() -> void:
	SceneManager._main_scene = self
	SceneManager.change_scene("Circle","res://Scenes/Gameplay.tscn",false,true)
