extends Weapon
class_name Grenade
func get_class(): return "Grenade"

onready var area_of_effect:Area = $Area
onready var timer:Timer = $Timer

func _ready():
	item_name = "Grenade"	

func explode():
	print("explode")
	var bodies = area_of_effect.get_overlapping_bodies()

	for body in bodies:
		if body is RigidBody:
			var direction = (self.global_transform.origin - body.global_transform.origin).normalized()
			
			if body != self:
				body.apply_central_impulse(-direction * 50)
			

func primary_action():
	print("ran granade primary action")	
	self.throw_self(1)
	
func secondary_action():
	pass

func _on_Grenade_body_entered(body):
	if was_thrown:		
		was_thrown = false
		yield(get_tree().create_timer(3), "timeout")
		explode()
