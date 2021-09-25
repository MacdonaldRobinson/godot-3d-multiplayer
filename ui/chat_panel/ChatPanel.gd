extends VBoxContainer

onready var send_message:LineEdit = $HBoxContainer/SendMessage
onready var messages:RichTextLabel = $PanelContainer/Messages

func _process(delta):
	print_messages()

func print_messages():	
	messages.bbcode_text = ""
	messages.bbcode_enabled = true
	
	if !GameState.get_peers().has("world_data"):
		return
	
	var world_data:WorldData = GameState.get_peers().world_data
	
	if world_data:		
		for message in world_data.messages:
			if message is Message:
				messages.append_bbcode(""+message.from_peer_name+": "+message.text+"\n")
		
func _on_SendMessage_text_entered(new_text):
	var message:Message = Message.new()
	message.from_peer_name = Globals.peer_data.peer_name
	message.text = new_text
	
	if !GameState.get_peers().has("world_data"):
		GameState.get_peers().world_data = WorldData.new()
	
	var world_data:WorldData = GameState.get_peers().world_data
	
	if world_data:
		world_data.messages.append(message)
		send_message.text = ""
