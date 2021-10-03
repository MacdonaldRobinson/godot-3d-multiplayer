extends Weapon
class_name Grenade
func get_class(): return "Grenade"

onready var area_of_effect:Area = $Area
onready var timer:Timer = $Timer

func _ready():
	item_name = "Grenade"	

func _on_Timer_timeout():
	#print("explode")
	var bodies = area_of_effect.get_overlapping_bodies()
	
	for body in bodies:
		if body is KinematicBody:
			var direct_space_state = get_world().direct_space_state
			var collision = direct_space_state.intersect_ray(global_transform.origin, body.global_transform.origin)
			
			if collision:
				print(collision.collider.name)
			
			print(body)
			
						
remote func _throw_self():
	print("throw")
	

func primary_action():
	print("ran granade primary action")	
	self.throw_self(1)
	timer.start()
	
func secondary_action():
	pass

