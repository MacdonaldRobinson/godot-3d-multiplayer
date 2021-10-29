extends Weapon
class_name FlameThrower

func get_class(): return "FlameThrower"

onready var emission_point:Position3D = $EmissionPoint
onready var flames:Particles = $EmissionPoint/Flames
onready var area_of_effect:Area = $Area

var timer:Timer = Timer.new()

func _ready():	
	self.item_name = "Flame Thrower"
	animation_state = animation_states.riffle
	
	flames.emitting = false
	flames.one_shot = true
	self.can_stack = false
	
	var primary_item_collector:ItemCollector = ItemCollector.new()
	primary_item_collector.current_amount = -1
	primary_item_collector.max_capacity = -1	
	primary_item_collector.item_name = "Fuel"
	
	self.set_primary_item_collector(primary_item_collector)
	
	add_child(timer)
	
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", self, "_on_Timer_timeout")
	
	
func primary_action():
	if self.can_use_primary_item():
		.primary_action()
		flames.emitting = true
		
		var bodies = area_of_effect.get_overlapping_bodies()
		
		for body in bodies:
			if body is Interactable:
				body.take_damage(1)
				
		timer.start(0.1)


func _on_Timer_timeout():
	print("ran")
	flames.emitting = false
		
	
