extends Node

var _world_data:WorldData = WorldData.new()

func add_player_to_world(peer_id):
	if get_players_node() == null:
		return
			
	var peer_data:PeerData = get_peer_data(peer_id)
	var player = null
	
	if get_players_node().has_node(String(peer_id)):
		player = get_players_node().get_node(String(peer_id))
			
	player = load("res://player/Player.tscn").instance()
	player.name = String(peer_id)			
	player.disable_cameras()
	
	player.set_network_master(peer_id, true)
	get_players_node().add_child(player)
	pass

func get_world_data() -> WorldData:
	return _world_data
	
func get_chat_messages()->Array:
	if !get_world_data():
		return []
		
	return get_world_data().messages
	
func get_player_node(id) -> Node:
	if get_players_node():
		return get_players_node().get_node(String(id))
	return null
	
func get_players_node() -> Node:
	return Globals.get_players_node()

func get_peers() -> Dictionary:
	if !get_world_data():
		return {}
		
	return get_world_data().peers
		
func get_peer_data(peer_id:int) -> PeerData:
	if get_world_data().peers.has(peer_id):
		var peer_data = get_world_data().peers[peer_id]
		return peer_data
	return PeerData.new()

func start_game():
	if Globals.is_network_server():
		rpc("_start_game")
		get_world_data().has_game_started = true
	
func add_chat_message(message:Message):
	if Globals.is_network_peer_connected():
		rpc("_add_chat_message", var2str(message))
		pass

func set_peer_data(peer_id:int, peer_data:PeerData):
	if Globals.is_network_peer_connected():
		
		if get_peers().has(peer_id) and var2str(get_peer_data(peer_id)) == var2str(peer_data):
			return

		rpc("_set_peer_data", peer_id, var2str(peer_data))
	
func remove_peer(id):
	if Globals.is_network_peer_connected():
		rpc("_remove_peer", id)
		pass

func set_world_data(world_data:WorldData):
	if Globals.is_network_server():
		rpc("_set_world_data", var2str(world_data))
	pass
	
func set_world_data_for_peer(peer_id:int, world_data:WorldData):
	if Globals.is_network_server():
		rpc_id(peer_id, "_set_world_data", var2str(world_data))
	pass
	
func sync_world_data_with_peers():
	if Globals.is_network_server():
		set_world_data(get_world_data())	
	
func sync_world_data_with_peer(peer_id:int):
	if Globals.is_network_server():
		set_world_data_for_peer(peer_id, get_world_data())	

func call_peer_method(peer_id:int, peer_method_name:String, callback_method_name:String = ""):

	if callback_method_name:	
		rpc_id(peer_id, peer_method_name, callback_method_name)	
	else:
		rpc_id(peer_id, peer_method_name)			
	pass
	
remotesync func respond_to_peer_method_call(execute_method_name:String, callback_method_name:String):
	var caller_peer_id:int = get_tree().get_rpc_sender_id()
	var result = call(execute_method_name)
	rpc_id(caller_peer_id, callback_method_name, result)

remotesync func _start_game():
	var scene:PackedScene = load("res://worlds/levels/level1/Level1.tscn")
	get_tree().change_scene_to(scene)
	yield(get_tree().create_timer(1), "timeout")
	
	for peer_id in get_world_data().peers:
		add_player_to_world(peer_id)
		
remotesync func _set_world_data(world_data:String):
	_world_data = str2var(world_data)
	
remotesync func _add_chat_message(message:String):
	get_chat_messages().append(str2var(message))

remotesync func _set_peer_data(peer_id:int, peer_data:String):
	var deserialized:PeerData = str2var(peer_data)	
	get_world_data().peers[peer_id] = deserialized
	
	if Globals.is_network_server():
		sync_world_data_with_peers()
	
remotesync func _remove_peer(id):
	get_world_data().peers.erase(id)
	var player_node = get_player_node(id)
	
	if player_node:
		get_players_node().remove_child(player_node)
	
	
