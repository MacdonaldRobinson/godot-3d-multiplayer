extends Spatial

class_name Level

func _ready():
	if get_tree().network_peer == null:
		return
		
	if is_network_master():
		return
		
	if Globals.get_players_node().get_child_count() == 0:
		var player:Player = preload("res://Player.tscn").instance()
		Globals.get_players_node().add_child(player)
