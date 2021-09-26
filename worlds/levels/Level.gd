extends Spatial
class_name Level


remote func update_node(node_path:String, global_transform:String):
	var node = get_node(node_path)
	if node is RigidBody:
		node.mode = RigidBody.MODE_KINEMATIC
	
	var new_global_transform = str2var(global_transform)		
	node.global_transform = new_global_transform
	
func _process(delta):
	if get_tree().is_network_server():	
		var nodes = get_tree().current_scene.get_children()
		nodes.append_array($Interactables.get_children())			
		
		for node in nodes:
			if node is RigidBody:
				if "global_transform" in node:
					var node_path = node.get_path()
					var global_transform_string = var2str(node.global_transform)
					
					rpc("update_node", node_path, global_transform_string)
