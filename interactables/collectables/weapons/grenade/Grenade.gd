extends Weapon
class_name Grenade
func get_class(): return "Grenade"

func _ready():
	item_name = "Grenade"	

func _on_Timer_timeout():
	print("ran")
	queue_free()

func primary_action():
	print("ran granade primary action")
	self.throw_self()
	$Timer.start()
	
func secondary_action():
	pass

