extends Spatial

onready var inner_wall:CSGBox = $Outer/Inner


func _on_GoalArea_body_entered(body):
	if body is Ball:
		print("goal")
