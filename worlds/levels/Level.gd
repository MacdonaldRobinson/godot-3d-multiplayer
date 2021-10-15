extends Spatial
class_name Level

#func _ready():
#	if Globals.is_network_server():
#		set_process(true)
#	else:
#		set_process(false)
#var previous:Dictionary = {}

remote func _rpc_node_removed(node_path:String):
	if has_node(node_path):
		var node = get_node(node_path)
		var parent_node = node.get_parent()			
		parent_node.remove_child(node)

remote func update_node(node_path:String, global_transform:String):		
	if has_node(node_path):
		var node = get_node(node_path)
		if node:
			if node is Interactable:
				if "global_transform" in node:
					var new_global_transform = str2var(global_transform)		
					node.global_transform = new_global_transform

remote func remove_node(node_path:String):
	if has_node(node_path):
		var node = get_node(node_path)
		node.get_parent().remove_child(node)

func _process(event):
	if !Globals.is_network_peer_connected():
		return
	
	if !Globals.is_network_server():	
		return

	var nodes = get_tree().current_scene.get_children()
	nodes.append_array($Interactables.get_children())	
	
	for node in nodes:
		if node is Interactable and node.is_inside_tree():
			if "global_transform" in node:
#				if !Globals.is_network_server():
#					node.mode = RigidBody.MODE_KINEMATIC
#					continue;
					
				var node_path:String = node.get_path()
				var global_transform_string = var2str(node.global_transform)					

				#if !previous.has(node_path) or previous[node_path] != global_transform_string:			
				rpc("update_node", node_path, global_transform_string)
					#previous[node_path] = global_transform_string

				if node.global_transform.origin.y < -50:

					remove_node(node_path)
					rpc("_rpc_node_removed", node_path)

#					if previous.has(node_path):
#						previous.erase(node_path)
