extends Node
 
sync var _peers:Dictionary = {}

func _process(delta):
	if Globals.is_network_peer_connected():
		
		var id = get_tree().get_network_unique_id()
		
		#Globals.log("self "+String(id), String(Globals.peer_data.health) +" | "+String(Globals.peer_data.energy))
		
		set_peer_data(id, Globals.peer_data)

		rset("_peers", _peers)

		create_and_update_players()


func create_and_update_players():
	if get_players_node() == null:
		return
		
	for peer_id in get_peers():
		var player:Player = get_players_node().get_node(String(peer_id))
		var peer_data:PeerData = get_peer_data(peer_id)
		
		if player == null:
			player = load("res://player/Player.tscn").instance()
			player.name = String(peer_id)			
			player.disable_cameras()
			player.connect("ready", self, "update_player_node", [peer_id, peer_data])
			
			player.set_network_master(peer_id)
			get_players_node().add_child(player)
		else:
			var id = get_tree().network_peer.get_unique_id()
			if id != peer_id:
				update_player_node(peer_id, peer_data)
				
func update_player_node(peer_id, peer_data:PeerData):
	var player_node:Player = get_player_node(peer_id);

	if player_node and peer_data: 
		#Globals.log("peers "+String(peer_id), String(peer_data.health) +" | "+String(peer_data.energy))
			
		player_node.set_from_peer_data(peer_data)
					
	
func get_player_node(id) -> Node:
	return get_players_node().get_node(String(id))
	
func get_players_node() -> Node:
	return Globals.get_players_node()
	
func get_peers() -> Dictionary:
	return GameState._peers
	
func get_peer_data(peer_id:int) -> PeerData:
	var peer_data = GameState._peers[peer_id]
	var deserialized:PeerData = str2var(peer_data)
	return deserialized

func set_peer_data(peer_id:int, peer_data:PeerData):
	var serialized = var2str(peer_data)
	GameState._peers[peer_id] = serialized
	
func start_game():
	get_tree().change_scene("res://worlds/levels/level1/Level1.tscn")

func remove_peer(id):
	_peers.erase(id)
	var player_node = get_player_node(id)
	
	if player_node:
		get_players_node().remove_child(player_node)
	
	
