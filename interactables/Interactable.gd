extends Node
class_name Interactable
func get_class(): return "Interactable"

var item_name:String = "Item Name"
var interacting_body:PhysicsBody = null

func disable_collisions():
	for child in self.get_children():
		if child is CollisionShape:
			child.disabled = true
		else:
			for c in child.get_children():
				if c is CollisionShape:
					c.disabled = true	

func enable_collisions():
	for child in self.get_children():
		if child is CollisionShape:
			child.disabled = false
		else:
			for c in child.get_children():
				if c is CollisionShape:
					c.disabled = false	

func interact(interacting_body):
	self.interacting_body = interacting_body
	print("Called base Interactable")
