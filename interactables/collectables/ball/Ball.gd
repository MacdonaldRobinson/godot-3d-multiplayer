extends Weapon

class_name Ball
# Called when the node enters the scene tree for the first time.
func _ready():
	self.item_name = "Ball"

func shoot():
	print("throw")