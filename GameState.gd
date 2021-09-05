extends Node
 
sync var peers:Dictionary = {}
var random_number_generator = RandomNumberGenerator.new()

func _process(delta):
	if get_tree().network_peer:		
		var id = get_tree().get_network_unique_id()
		peers[id] = inst2dict(Globals.character_data)		
		rset("peers", peers)
		
		Globals.log("peers", peers.size())
		create_and_update_players()

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
			
			player.connect("ready", self, "update_player_node", [peer_id, peer_data])
			
			player.set_network_master(peer_id)
			get_players_node().add_child(player)
		else:
			var id = get_tree().network_peer.get_unique_id()
			Globals.log("update"+String(id), peer_id)
			if id != peer_id:
				update_player_node(peer_id, peer_data)
				
func update_player_node(peer_id, peer_data:CharacterData):
	var player_node:Player = get_player_node(peer_id);
	
	if player_node and peer_data: 
		player_node.display_name.set_text(peer_data.display_name)
		player_node.global_transform = peer_data.global_transform
					
	
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

func add_or_update_peer(peer_id, peer_data:CharacterData):
	peers[peer_id] = inst2dict(peer_data)	
		
func remove_peer(id):
	#print("remove_peer", id)
	peers.erase(id)
