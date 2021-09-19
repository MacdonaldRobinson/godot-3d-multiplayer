tool
extends Sprite3D

class_name Progress3D

var value = 100
onready var _progress_bar = $Viewport/ProgressBar/ProgressBar

func _ready():
	texture = $Viewport.get_texture()

func _process(delta):
	texture = $Viewport.get_texture()
	_progress_bar.value = value
