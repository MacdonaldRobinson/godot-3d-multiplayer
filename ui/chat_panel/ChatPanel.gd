extends VBoxContainer
class_name ChatPanel
func get_class(): return "ChatPanel"

onready var send_button:Button = $HBoxContainer/SendButton
onready var send_message:LineEdit = $HBoxContainer/SendMessage
onready var messages:RichTextLabel = $PanelContainer/Messages

func _process(delta):
	if Globals.is_network_peer_connected():
		print_messages()

func print_messages():	
	messages.bbcode_text = ""
	messages.bbcode_enabled = true
	
	for message in GameState.get_chat_messages():
		if message is Message:
			messages.append_bbcode(""+message.from_peer_name+": "+message.text+"\n")

	
func _on_SendMessage_text_entered(new_text):
	send_button.emit_signal("pressed")

func _on_SendButton_pressed():
	var message:Message = Message.new()
	message.from_peer_name = Globals.peer_data.peer_name
	message.text = send_message.text
	
	GameState.add_chat_message(message)
	send_message.text = ""	
