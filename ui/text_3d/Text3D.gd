extends Sprite3D

class_name Text3D

func _ready():
	self.texture = $Viewport.get_texture()

func set_text(text):
	$Viewport/Label.text = text
