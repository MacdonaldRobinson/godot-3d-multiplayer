extends Spatial

class_name Interactable

var item_name:String = "Item Name"

func interact(body):
	print("Called base interact")

func is_body_player(body):
	return body.get_class() == "Player"
	
#func pickup(holder):
#	print("Called base pickup")
#	var self_parent = self.get_parent();
#
#	self_parent.remove_child(self)
#
#	for child in holder.get_children():
#		holder.remove_child(child)		
#		child.transform = self.transform
#		self_parent.add_child(child)
#
#	self.rotation = Vector3.ZERO
#	self.transform.origin = Vector3.ZERO
#	holder.add_child(self)
