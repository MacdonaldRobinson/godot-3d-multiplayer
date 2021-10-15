extends Spatial
class_name OverHeadBars

onready var _name_bar:Text3D = $NameBar
onready var _health_bar:OverHeadHealthBar = $HealthBar

var initial_transform:Transform
var initial_global_transform:Transform

func _ready():
	initial_transform = self.transform
	initial_global_transform = self.global_transform
	
	set_as_toplevel(true)
	
func _process(delta):
	self.global_transform.origin = get_parent().global_transform.origin + initial_transform.origin

func get_health_bar()->OverHeadHealthBar:
	return _health_bar

func get_name_bar()->Text3D:
	return _name_bar
