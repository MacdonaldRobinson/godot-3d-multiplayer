extends Interactable

func interact(body):
	if body != null and body is Player:
		var player = body as Player				
		player.health = player.health + 1
