extends Interactable
class_name HealthRefillStation
func get_class(): return "HealthRefillStation"

func interact():
	if interacting_body != null:
		if interacting_body.has_method("recover_health"):
			interacting_body.recover_health(1)
		
