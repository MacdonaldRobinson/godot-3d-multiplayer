extends Node
 
var _world_data:WorldData = WorldData.new()

func _process(delta):
	if Globals.is_network_peer_connected():
		#Globals.log("_world_data", _world_data)
		
		var id = get_tree().get_network_unique_id()
		GameState.set_peer_data(id, Globals.peer_data)

		create_and_update_players()

func create_and_update_players():
	if get_players_node() == null:
		return
		
	for peer_id in get_peers():
		var peer_data:PeerData = get_peer_data(peer_id)
		var player:Player = null
		
		if get_players_node().has_node(String(peer_id)):
			player = get_players_node().get_node(String(peer_id))
		
		if player == null:
			player = load("res://player/Player.tscn").instance()
			player.name = String(peer_id)			
			player.disable_cameras()
			player.connect("ready", self, "update_player_node", [peer_id, peer_data])
			
			player.set_network_master(peer_id)
			get_players_node().add_child(player)
		else:
			update_player_node(peer_id, peer_data)
				
func update_player_node(peer_id, peer_data:PeerData):
	var player_node:Player = get_player_node(peer_id);

	if player_node and peer_data: 
		#Globals.log("peers "+String(peer_id), String(peer_data.health) +" | "+String(peer_data.energy))
			
		player_node.set_from_peer_data(peer_data)
		

func get_world_data() -> WorldData:
	return GameState._world_data
	
func get_chat_messages()->Array:
	if !GameState.get_world_data():
		return []
		
	return GameState.get_world_data().messages
	
func get_player_node(id) -> Node:
	if get_players_node():
		return get_players_node().get_node(String(id))
	return null
	
func get_players_node() -> Node:
	return Globals.get_players_node()

func get_peers() -> Dictionary:
	if !GameState.get_world_data():
		return {}
		
	return GameState.get_world_data().peers
		
func get_peer_data(peer_id:int) -> PeerData:
	var peer_data = GameState.get_world_data().peers[peer_id]
	return peer_data


func start_game():
	if Globals.is_network_peer_connected():
		_start_game()
		#rpc_unreliable("_start_game")	
	
func add_chat_message(message:Message):
	if Globals.is_network_peer_connected():
		rpc_unreliable("_add_chat_message", var2str(message))

func set_peer_data(peer_id:int, peer_data:PeerData):
	if Globals.is_network_peer_connected():		
		rpc_unreliable("_set_peer_data", peer_id, var2str(peer_data))
	
func remove_peer(id):
	if Globals.is_network_peer_connected():
		rpc_unreliable("_remove_peer", id)

func set_world_data(world_data:WorldData):
	rpc_unreliable("_set_world_data", var2str(world_data))

func call_peer_method(peer_id:int, peer_method_name:String, callback_method_name:String):
	rpc_id(peer_id, peer_method_name, callback_method_name)	

remotesync func respond_to_peer_method_call(execute_method_name:String, callback_method_name:String):
	var caller_peer_id:int = get_tree().get_rpc_sender_id()
	var result = call(execute_method_name)
	rpc_id(caller_peer_id, callback_method_name, result)

remotesync func _start_game():
	var scene:PackedScene = load("res://worlds/levels/level1/Level1.tscn")
	get_tree().change_scene_to(scene)
	
remotesync func _set_world_data(world_data:String):
	GameState._world_data = str2var(world_data)
	
remotesync func _add_chat_message(message:String):
	get_chat_messages().append(str2var(message))

remotesync func _set_peer_data(peer_id:int, peer_data:String):
	var deserialized:PeerData = str2var(peer_data)	
	GameState.get_world_data().peers[peer_id] = deserialized
	
	if get_tree().is_network_server():
		GameState.set_world_data(GameState.get_world_data())
	
remotesync func _remove_peer(id):
	GameState.get_world_data().peers.erase(id)
	var player_node = get_player_node(id)
	
	if player_node:
		get_players_node().remove_child(player_node)
	
	
