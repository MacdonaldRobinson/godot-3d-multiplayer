extends RigidBody

class_name Ammo

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_Area_body_entered(body):
	pass


func _on_Timer_timeout():
	queue_free()
