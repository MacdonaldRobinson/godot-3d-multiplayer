extends Node

var character_data:CharacterData = CharacterData.new()

func _ready():	
	pass

func get_mapped_keys(action):
	var mapped_keys = []
	var keys = InputMap.get_action_list(action)
	for key in keys:
		mapped_keys.push_back(OS.get_scancode_string(key.scancode))

	return mapped_keys

func get_interact_message():
	var message = "Press " + String(Globals.get_mapped_keys("interact")) + " to interact with this item"
	return message

func get_collected_message(count, item:Collectable):
	var message = "You have collected ("+String(count)+") "+ String(item.item_name)
	return message
