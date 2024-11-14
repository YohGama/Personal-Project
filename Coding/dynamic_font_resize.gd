extends Label

var _text : String = ""

@export var min_font_size: int = 8
@export var max_font_size: int = 100

signal text_changed


func fit_text() :

	var font_size = max_font_size

	while font_size >= min_font_size:
		print("font size : "+str(font_size))
		print("label : "+str(label_settings.font_size))
		label_settings.font_size = font_size
		var text_size = get_minimum_size()

		if text_size.x <= custom_minimum_size.x and text_size.y <= custom_minimum_size.y:
			break
		font_size -= 1

	label_settings.font_size = font_size
	#size = custom_minimum_size

func _ready():
	fit_text()
	resized.connect(_on_resize)
	text_changed.connect(fit_text)

func _process(delta: float) -> void:
	if _text != text :
		emit_signal("text_changed")
		_text = text

func _on_resize():
	fit_text()
