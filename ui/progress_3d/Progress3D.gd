tool
extends Sprite3D

class_name Progress3D

var value = 100

onready var _viewport:Viewport = $Viewport
onready var _progress_bar = $Viewport/ProgressBar/ProgressBar

func _ready():
	if _viewport:
		texture = _viewport.get_texture()

func _process(delta):
	if _viewport and _progress_bar:
		texture = _viewport.get_texture()
		_progress_bar.value = value
