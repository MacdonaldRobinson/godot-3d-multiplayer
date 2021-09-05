tool
extends Viewport

onready var label:Label = $Label

func _ready():
	self.size = $Label.rect_size
