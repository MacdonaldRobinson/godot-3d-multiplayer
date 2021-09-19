tool
extends Sprite3D

class_name Text3D

onready var _viewport:Viewport = $Viewport
onready var _label:Label = $Viewport/Label

func _ready():
	if _viewport:
		self.texture = _viewport.get_texture()

func set_text(text):
	_label.text = text

func _process(delta):
	if _viewport:
		texture = _viewport.get_texture()
