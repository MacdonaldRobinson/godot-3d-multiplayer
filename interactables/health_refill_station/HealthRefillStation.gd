extends Interactable
class_name HealthRefillStation
func get_class(): return "HealthRefillStation"

func interact():
	if interacting_body != null and interacting_body is Player:
		var player = interacting_body as Player	
		player.health = player.health + 1
