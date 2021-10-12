extends Control
class_name PopupWindowUI

onready var _middle:ScrollContainer = $VBoxContainer/Middle
signal close_window

var _config:PopupWindowUIConfig = PopupWindowUIConfig.new()

func _ready():
	self.show()
	
func update_data(config:PopupWindowUIConfig):	
	_config = config
	rect_size = _config.rect_size
	rect_global_position = config.rect_global_position

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if self is Control:
				var parent = self.get_parent()
				parent.move_child(self, parent.get_child_count())

func _on_CloseButton_pressed():
	emit_signal("close_window")
