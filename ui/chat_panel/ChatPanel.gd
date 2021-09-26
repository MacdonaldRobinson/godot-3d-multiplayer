extends VBoxContainer
class_name ChatPanel

onready var send_message:LineEdit = $HBoxContainer/SendMessage
onready var messages:RichTextLabel = $PanelContainer/Messages

func _process(delta):
	print_messages()

func print_messages():	
	messages.bbcode_text = ""
	messages.bbcode_enabled = true
	
	for message in GameState.get_chat_messages():
		if message is Message:
			messages.append_bbcode(""+message.from_peer_name+": "+message.text+"\n")

	
func _on_SendMessage_text_entered(new_text):
	var message:Message = Message.new()
	message.from_peer_name = Globals.peer_data.peer_name
	message.text = new_text
	
	GameState.add_chat_message(message)
	send_message.text = ""
	
