extends ItemCollector
class_name AmmoCollector
func get_class(): return "AmmoCollector"

func _ready():
	item_name = "Ammo Name"
	current_amount = -1
	max_capacity = -1
