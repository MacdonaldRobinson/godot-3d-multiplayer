extends Spatial

class_name Level

func get_nodes_to_sync() -> Array:
	var nodes:Array = []
	
	for child in $Interactables.get_children():
		if child is RigidBody:
			if !nodes.has(child):
				nodes.append(child)

#	for child in get_tree().current_scene.get_children():
#		if child is RigidBody:
#			if !nodes.has(child):
#				nodes.append(child)

	return nodes

func _process(delta):
	if get_tree().is_network_server():
		var world_data = GameState.get_world_data()
		
		world_data.sync_from_server_nodes = {}
		for node in get_nodes_to_sync():
			if node is Node:
				var node_data:NodeData = NodeData.new()
				node_data.name = node.name	
				node_data.filename = node.filename		
				node_data.parent_path = node.get_parent().get_path()
				node_data.global_transform = node.global_transform
			
				world_data.sync_from_server_nodes[node.get_path()] = node_data
		
	else:
		var world_data = GameState.get_world_data()
		for node in get_nodes_to_sync():
			if node is RigidBody:
				node.mode = RigidBody.MODE_KINEMATIC
		
		if world_data:
			var server_nodes = world_data.sync_from_server_nodes
			for node_path in world_data.sync_from_server_nodes:
				var entry:NodeData = server_nodes[node_path]
				
				if has_node(node_path):
					var node = get_node(node_path)
					if node is RigidBody:
						if "global_transform" in node and node.global_transform != entry.global_transform:
							node.global_transform = entry.global_transform
				else:
					if node_path is NodePath:
						node_path = node_path as NodePath
						node_path.get_as_property_path() 
						var new_node = load(entry.filename).instance()						

						var parent_node = get_node(entry.parent_path)

						if parent_node:
							parent_node.add_child(new_node)
							new_node.name = entry.name
							new_node.global_transform = entry.global_transform
