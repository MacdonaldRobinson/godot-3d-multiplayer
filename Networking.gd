extends Node

func _ready():
	get_tree().connect("connected_to_server", self, "connected_to_server")
	get_tree().connect("server_disconnected", self, "server_disconnected")
	get_tree().connect("connection_failed", self, "connection_failed")
	get_tree().connect("network_peer_connected", self, "network_peer_connected")
	get_tree().connect("network_peer_disconnected", self, "network_peer_disconnected")


func create_server(port, max_clients):
	var peer = NetworkedMultiplayerENet.new()	
	peer.create_server(int(port), int(max_clients))
	get_tree().network_peer = peer
	GameState.set_peer_data(peer.get_unique_id(), Globals.peer_data)	
	
func join_server(address, port):
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(String(address), int(port))	
	get_tree().network_peer = peer
	
func connected_to_server():
	print("connected_to_server")
	pass
func server_disconnected():
	print("server_disconnected")	
	GameState.peers = {}
	get_tree().network_peer = null
	get_tree().change_scene("res://Lobby.tscn")
	pass	
	
func connection_failed():
	print("connection_failed")
	pass
	
func network_peer_connected(id):	
	print("network_peer_connected: ", id)
	GameState.set_peer_data(id, PeerData.new())
	pass
	
func network_peer_disconnected(id):
	print("network_peer_disconnected: ", id)
	GameState.remove_peer(id)
	
	pass		
