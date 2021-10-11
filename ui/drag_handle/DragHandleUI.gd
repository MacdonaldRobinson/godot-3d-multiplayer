extends Control
class_name DragHandleUI

var _config:DragHandleUIConfig
var _start_drag:bool = false
var _drag_position = null

func _ready():
	var config:DragHandleUIConfig = DragHandleUIConfig.new()
	config.control_to_drag = self.get_parent().owner
	setup(config)

func setup(config:DragHandleUIConfig):
	_config = config
	connect("gui_input", self, "_gui_input")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == 1:
			_start_drag = true
			_drag_position = get_global_mouse_position() - _config.control_to_drag.rect_global_position

			var parent = _config.control_to_drag.get_parent()
			
			if parent:
				parent.move_child(_config.control_to_drag, parent.get_child_count())
		else:
			_start_drag = false

	if event is InputEventMouseMotion:
		mouse_default_cursor_shape = Control.CURSOR_MOVE
		
		if _start_drag:
			_config.control_to_drag.rect_position = get_global_mouse_position() - _drag_position
	else:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
		
