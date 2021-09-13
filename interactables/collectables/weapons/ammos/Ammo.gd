extends RigidBody
class_name Ammo

func _ready():
	pass

func _on_Timer_timeout():
	queue_free()


func _on_Area_body_entered(body):
	if body is Player:
		var player = body as Player
		player.health = player.health - 1
		queue_free()
