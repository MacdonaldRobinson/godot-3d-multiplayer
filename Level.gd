extends Spatial

class_name Level

func _ready():
	if Globals.get_players_node().get_child_count() == 0 and get_tree().network_peer == null:
		var player:Player = preload("res://Player.tscn").instance()
		Globals.get_players_node().add_child(player)
