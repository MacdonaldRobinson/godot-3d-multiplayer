extends VBoxContainer
class_name DialogPanel
func get_class(): return "DialogPanel"

onready var text_box = $ColorRect/MarginContainer/Label

func _ready():
	pass # Replace with function body.

func _process(delta):
	if text_box.percent_visible < 1:
		text_box.percent_visible+= 0.1

func set_text(var text):
	self.visible = true	
	if text_box.text != text:
		text_box.text = text	
		text_box.percent_visible = 0
	
