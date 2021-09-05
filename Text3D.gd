extends Sprite3D

class_name Text3D

onready var label:Label = $Viewport/Label

func set_text(text):
	if label:
		label.text = text
