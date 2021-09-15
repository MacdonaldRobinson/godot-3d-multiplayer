extends Interactable
class_name HealthRefillStation

func interact(body):
	if body != null and body is Player:
		var player = body as Player	
		player.health = player.health + 1
