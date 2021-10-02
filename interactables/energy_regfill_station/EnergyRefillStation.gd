extends Interactable
class_name EnergyRefillStation
func get_class(): return "EnergyRefillStation"

func interact(body):
	if body != null and body is Player:
		var player = body as Player		
		player.energy = player.energy + 1
