extends Control
class_name WordLabel

@export var label : Label
var text : String

func _ready() -> void:
	SignalBus.word_logic_completed.connect(_on_word_logic_completed)

func _process(delta: float) -> void:
	label.text = text

func set_text( new_text : String ) :
	text = new_text

func _on_word_logic_completed() -> void :
	text = ""
