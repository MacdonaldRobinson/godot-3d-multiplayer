extends Area

onready var parent:Spatial = get_parent()

func _on_Area_body_entered(body):
	if body is Spatial:
		var diff = (parent.global_transform.origin - body.global_transform.origin)
		parent.global_transform.origin = lerp(parent.global_transform.origin,  parent.global_transform.origin - diff, 0.1)
