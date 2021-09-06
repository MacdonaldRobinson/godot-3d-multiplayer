extends Interactable

class_name Collectable

func _ready():
	pass # Replace with function body.
	
func shoot(body = null):
	if body == null:
		body = self
		
	if body != null:		
		var rigid_body = body as RigidBody;
		rigid_body.rotation = Vector3.ZERO
		rigid_body.transform.origin = Vector3.ZERO
		rigid_body.linear_velocity = Vector3.ZERO
		rigid_body.angular_velocity = Vector3.ZERO
		
		rigid_body.set_as_toplevel(true)
		rigid_body.apply_central_impulse(-self.global_transform.basis.z * 50)
