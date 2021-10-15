extends Spatial
class_name OverHeadHealthBar

onready var progress_3d:Progress3D = $Progress3D

func reduce_by(amount:int):
	progress_3d.value -= amount

func increase_by(amount:int):
	progress_3d.value += amount

func get_current_health():
	return progress_3d.value
