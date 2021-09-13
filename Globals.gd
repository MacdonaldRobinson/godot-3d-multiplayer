extends Node

var peer_data:PeerData = PeerData.new()
var delayed_logs:Dictionary = {}

func _ready():
	var timer = Timer.new()	
	timer.connect("timeout", self,"timer_timeout")
	add_child(timer)
	timer.start(2)
	
func get_players_node() -> Node:
	var current_scene = get_tree().current_scene
	
	if current_scene != null and current_scene.has_node("Players"):
		return current_scene.get_node("Players")
	else:
		return null
	
func timer_timeout():
	for entry_key in delayed_logs:
		print(entry_key, " -> ", delayed_logs[entry_key])
		
func log(key:String, data):
	if data is Object:
		delayed_logs[key] = inst2dict(data)
	else:
		delayed_logs[key] = data

func are_the_same(item1, item2) -> bool:
	if item1 is Object:
		item1 = inst2dict(item1)
	if item2 is Object:
		item2 = inst2dict(item2)
	
	item1 = to_json(item1)
	item2 = to_json(item2)
	
	return item1 == item2
	
func get_gd_script_path(node:Node):
	var path_to_gd_script:String = node.get("script").resource_path
	return path_to_gd_script

func get_tscn_path(node:Node):
	var path_to_gd_script:String = node.get("script").resource_path
	var path_to_tscn = path_to_gd_script.replace(".gd", ".tscn")
	
	return path_to_tscn

func smooth_look_at(object_global_transform:Transform, look_at_point:Vector3) -> Transform:
	var looking_at = object_global_transform.looking_at(look_at_point, Vector3.UP)
	return object_global_transform.interpolate_with(looking_at, 0.1)	

func get_mapped_keys(action):
	var mapped_keys = []
	var keys = InputMap.get_action_list(action)
	for key in keys:
		mapped_keys.push_back(OS.get_scancode_string(key.scancode))

	return mapped_keys
	
func create_event(action:String):
	var event = InputEventAction.new()
	event.action = action
	event.pressed = true
	
	return event
	
func raise_event(event):
	Input.parse_input_event(event)
	
func is_network_peer_connected():
	if get_tree().network_peer == null:
		return false
			
	if get_tree().network_peer.get_connection_status() == NetworkedMultiplayerENet.CONNECTION_CONNECTED:
		return true
	else:
		return false
	
func throw_exception(message:String):
	push_error(message)
	assert(false)	

func get_interact_message():
	var message = "Press " + String(Globals.get_mapped_keys("interact")) + " to interact with this item"
	return message

func get_collected_message(count, item:Collectable):
	var message = "You have collected ("+String(count)+") "+ String(item.item_name)
	return message
