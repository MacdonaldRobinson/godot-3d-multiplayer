extends Interactable

func interact(body):
	if body != null and body is Player:
		var player = body as Player		
		player.energy = player.energy + 1
