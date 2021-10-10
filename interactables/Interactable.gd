extends RigidBody
class_name Interactable
func get_class(): return "Interactable"

var item_name:String = "Item Name"
var interacting_body:PhysicsBody = null
var interacting_ray_cast:RayCast

export(Texture) var item_icon_texture:Texture

func _ready():
	pass
	
func set_interacting_body(interacting_body:PhysicsBody):
	self.interacting_body = interacting_body
	
func set_interacting_ray_cast(interacting_ray_cast:RayCast):
	self.interacting_ray_cast = interacting_ray_cast

func disable_collisions():
	var item = self
	if item is RigidBody:
		item.mode = RigidBody.MODE_KINEMATIC
		
	for child in self.get_children():
		if child is CollisionShape:
			child.disabled = true
		else:
			for c in child.get_children():
				if c is CollisionShape:
					c.disabled = true	

func enable_collisions(exception_objects:Array = []):
	var item = self
	
	if item is RigidBody:
		item.mode = RigidBody.MODE_RIGID
	
	if item is PhysicsBody:
		for obj in exception_objects:
			item.add_collision_exception_with(obj)
	
	for child in item.get_children():
		if child is PhysicsBody:
			for obj in exception_objects:
				child.add_collision_exception_with(obj)
				
		if child is CollisionShape:
			child.disabled = false			
		else:
			for c in child.get_children():
				if c is CollisionShape:
					c.disabled = false	

func interact():
	print("Called base Interactable")
