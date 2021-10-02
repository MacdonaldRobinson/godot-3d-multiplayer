extends Interactable
class_name EnergyRefillStation
func get_class(): return "EnergyRefillStation"

func interact():
	if interacting_body != null and interacting_body is Player:
		var player = interacting_body as Player		
		player.energy = player.energy + 1
