extends Spatial
class_name Interactable

var item_name:String = "Item Name"
var interacting_body:PhysicsBody = null

func interact(interacting_body):
	self.interacting_body = interacting_body
	print("Called base Interactable")
