extends Weapon
class_name FlameThrower

func get_class(): return "FlameThrower"

onready var emission_point:Position3D = $EmissionPoint
onready var flames:Particles = $EmissionPoint/Flames
onready var area_of_effect:Area = $Area

func _ready():	
	self.item_name = "Flame Thrower"
	flames.emitting = false
	flames.one_shot = true
	
	var primary_item_collector:AmmoCollector = AmmoCollector.new()
	primary_item_collector.current_amount = -1
	primary_item_collector.max_capacity = -1	
	primary_item_collector.item_name = "Fuel"
	
	self.set_primary_item_collector(primary_item_collector)
	
func primary_action():
	if self.can_use_primary_item():
		.primary_action()
		flames.emitting = true
		
		yield(get_tree().create_timer(0.5), "timeout")
		
		var bodies = area_of_effect.get_overlapping_bodies()
		
		for body in bodies:
			if body is Player:
				body.health -= 1
		
		
	else:
		flames.emitting = false
		
	
