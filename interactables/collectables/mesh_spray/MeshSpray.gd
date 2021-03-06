extends Collectable
class_name MeshSpray
func get_class(): return "MeshSpray"

var item = preload("res://interactables/collectables/mesh_spray/structures/sprayable/Wall.tscn")
var spray:Sprayable = item.instance()

func _ready():
	self.item_name = "MeshSpray"
	animation_state = animation_states.magic
	spray.name = "spray"
	can_stack = false	
	
func setup_spray():
	if spray.mesh_instance:
		var material:SpatialMaterial = spray.mesh_instance.mesh.material.duplicate() as SpatialMaterial
		var collision_shape:CollisionShape = spray.collision_shape as CollisionShape
		
		collision_shape.disabled = true
		
		material.albedo_color = Color(1, 0, 0, 0.85)	
		material.flags_transparent = true

		spray.mesh_instance.material_override = material		

func primary_action():
	if weapon_ray_cast.is_colliding():
		var collider = weapon_ray_cast.get_collider()
		if not collider is Player:
			var create_at_position = weapon_ray_cast.get_collision_point()
			var normal = weapon_ray_cast.get_collision_normal()
			
			if Globals.is_network_peer_connected():
				rpc("_spray_mesh", var2str(spray.global_transform))				
			else:
				_spray_mesh(var2str(spray.global_transform))
			
func secondary_action():
	if weapon_ray_cast.is_colliding():
		var collider = weapon_ray_cast.get_collider()		
		if collider is Sprayable:
			if collider.get_parent():
				
				if Globals.is_network_peer_connected():
					rpc("_remove_colliding", collider.get_path())
					pass
				else:
					_remove_colliding(collider.get_path())

remotesync func _remove_colliding(collider_node_path:String):
	if has_node(collider_node_path):
		var node = get_node(collider_node_path)
		if node:
			var parent_node = node.get_parent()
			if parent_node:
				parent_node.remove_child(node)

remotesync func _spray_mesh(global_transform_string:String):
	var new_item:Spatial = item.instance()
	get_tree().current_scene.add_child(new_item, true)
	new_item.global_transform = str2var(global_transform_string)

remote func _update_spray_position(spray_global_transform:String):
	spray.global_transform = str2var(spray_global_transform)
	

func _process(delta):
	var parent = get_parent()	
	var owner = parent.get_owner()
	if owner is Player:
		var weapon_ray_cast:RayCast = owner._weapon_raycast
		weapon_ray_cast.add_exception(owner)
		weapon_ray_cast.add_exception(spray)
		
		if weapon_ray_cast.is_colliding():
			var collider = weapon_ray_cast.get_collider()
			if not collider is Player:
				var create_at_position = weapon_ray_cast.get_collision_point()
				var normal = weapon_ray_cast.get_collision_normal()

				if !owner.has_node(spray.name):
					owner.add_child(spray, true)
					setup_spray()
				
				if Globals.is_network_peer_connected():
					if owner.name != String(Globals.get_peer_id()):
						return
				
				if owner.has_node(spray.name):
					if Input.is_action_pressed("ui_left"):
						spray.rotation.z += deg2rad(1)
					elif Input.is_action_pressed("ui_right"):
						spray.rotation.z -= deg2rad(1)
					elif Input.is_action_pressed("ui_up"):						
						spray.rotation.x -= deg2rad(1)
					elif Input.is_action_pressed("ui_down"):						
						spray.rotation.x += deg2rad(1)
					else:
						spray.global_transform.origin = create_at_position + normal 
						
					Globals.peer_data.mesh_spray_global_transform = spray.global_transform
					
					if Globals.is_network_peer_connected():
						rpc("_update_spray_position", var2str(spray.global_transform))
						pass
									
		else:
			if owner and "has_node" in owner and owner.has_node(spray.name):
				owner.remove_child(spray)

	else:
		if owner and "has_node" in owner and owner.has_node(spray.name):
			owner.remove_child(spray)

