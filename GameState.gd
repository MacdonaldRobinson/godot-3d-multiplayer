extends Node
 
sync var peers:Dictionary = {}
var random_number_generator = RandomNumberGenerator.new()

func _process(delta):
	if get_tree().network_peer:
		var names = []
		for peer_id in peers:
			names.append(peers[peer_id].transform)
		
		#print(names)	
		var id = get_tree().get_network_unique_id()
		add_or_update_peer(id, Globals.character_data)		

		create_and_update_players()
				
		#if get_tree().is_network_server():
		rset("peers", peers)

func create_and_update_players():
	if get_players_node() == null:
		return
		
	var count = 0
	for peer_id in peers:
		count +=1
		var player:Player = get_players_node().get_node(String(peer_id))
		var peer_data:CharacterData = dict2inst(peers[peer_id])
		
		if player == null:
			player = preload("res://Player.tscn").instance()
			player.name = String(peer_id)
			player.disable_cameras()
			
			
			peer_data.transform.origin = Vector3(10 * count, 10 * count, 10 * count)
			player.connect("ready", self, "update_player_node", [peer_id, peer_data] )
			
			player.set_network_master(peer_id)
			get_players_node().add_child(player)


func update_player_node(peer_id, peer_data:CharacterData):
	var player_node:Player = get_player_node(peer_id);
	
	if player_node and peer_data: 
		player_node.display_name.set_text(peer_data.display_name)
		player_node.transform = peer_data.transform
	
func get_player_node(id) -> Node:
	return get_players_node().get_node(String(id))
	
func get_players_node() -> Node:
	var current_scene = get_tree().current_scene
	
	if current_scene != null and current_scene.has_node("Players"):
		return current_scene.get_node("Players")
	else:
		return null
	
func start_game():
	get_tree().change_scene("res://Level1.tscn")

func add_or_update_self():
	add_or_update_peer(get_tree().network_peer.get_unique_id(), Globals.character_data)

func add_or_update_peer(peer_id, peer_data:CharacterData):
	peers[peer_id] = inst2dict(peer_data)
	#print("add_or_update_peer", peers[peer_id])
		
func remove_peer(id):
	#print("remove_peer", id)
	peers.erase(id)
