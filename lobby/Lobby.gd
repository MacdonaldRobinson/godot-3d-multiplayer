extends Control

onready var players_connected_list:ItemList = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/PlayersConnectedList

onready var player_name_field:LineEdit = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer3/VBoxContainer/PlayerNameField
onready var port_number_field:LineEdit = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer2/VBoxContainer2/PortNumberField
onready var max_clients_field:LineEdit = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer2/VBoxContainer3/MaxClientsField
onready var game_time_field:LineEdit = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer3/VBoxContainer2/GameTimeField
onready var server_address_field:LineEdit  = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer2/VBoxContainer/ServerAddressField

onready var start_game_button:Button = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/StartGameButton
onready var join_button:Button = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer/Join
onready var host_button:Button = $CenterContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer/Host

func _ready():
	players_connected_list.clear();
	start_game_button.visible = false	

func _process(delta):
	if Globals.is_network_peer_connected():
		if get_tree().is_network_server():
			server_config()
		else:
			client_config()
	else:
		reset_buttons()

	if GameState.get_peers().size() == 0:
		reset_buttons()

	players_connected_list.clear()

	for peer_id in GameState.get_peers():
		var peer:PeerData = GameState.get_peer_data(peer_id)
		if peer:
			players_connected_list.add_item(peer.peer_name)	

func reset_buttons():
	start_game_button.visible = false
	host_button.visible = true
	join_button.visible = true

func server_config():
	start_game_button.visible = true
	host_button.visible = false
	join_button.visible = false
		
func client_config():
	start_game_button.visible = false
	host_button.visible = false
	join_button.visible = false

func _on_Host_pressed():
	Globals.peer_data.peer_name = player_name_field.text
	Networking.create_server(port_number_field.text, max_clients_field.text)
	
func _on_Join_pressed():
	Globals.peer_data.peer_name = player_name_field.text
	Networking.join_server(server_address_field.text, port_number_field.text)
	
func disable_buttons():
	join_button.disabled = true
	host_button.disabled = true
	
func enable_buttons():
	join_button.disabled = true
	host_button.disabled = true	

func _on_StartGameButton_pressed():	
	GameState.start_game()


func _on_CharacterSelectionScreen_pressed():
	get_tree().change_scene("res://character_selector/CharacterSelector.tscn")
