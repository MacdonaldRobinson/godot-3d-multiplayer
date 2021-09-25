extends Weapon
class_name Creator

var item = preload("res://interactables/collectables/weapons/creator/structures/mesh_spray/MeshSpray.tscn")
var spray:MeshSpray = item.instance()

func _ready():
	self.item_name = "Creator"
	self.max_capacity = -1
	self.current_ammo_amount = -1	
	spray.name = "spray"

func setup_spray():
	if spray.mesh_instance:
		var material:SpatialMaterial = spray.mesh_instance.mesh.material.duplicate() as SpatialMaterial
		var collision_shape:CollisionShape = spray.collision_shape as CollisionShape
		
		collision_shape.disabled = true
		
		material.albedo_color = Color(1, 0, 0, 0.85)	
		material.flags_transparent = true

		spray.mesh_instance.material_override = material	
	
func shoot(weapon_ray_cast:RayCast):
	if weapon_ray_cast.is_colliding():
		var collider = weapon_ray_cast.get_collider()
		if not collider is Player:
			var create_at_position = weapon_ray_cast.get_collision_point()
			var normal = weapon_ray_cast.get_collision_normal()
			
			var new_item:Spatial = item.instance()
			
			get_tree().current_scene.add_child(new_item, true)
			new_item.global_transform = spray.global_transform
			

func _process(delta):
	var parent = get_parent()	
	var owner = parent.get_owner()
	if owner is Player:
		setup_spray()
#		if owner.name != String(get_tree().get_network_unique_id()):
#			if !owner.has_node(spray.name):
#				owner.add_child(spray)
#
#			var peer_data = GameState.get_peer_data(int(owner.name))
#			if	peer_data:
#				spray.global_transform = peer_data.mesh_spray_global_transform
#			return
			
		var weapon_ray_cast:RayCast = owner._weapon_raycast
		weapon_ray_cast.add_exception(owner)
		if weapon_ray_cast.is_colliding():
			var collider = weapon_ray_cast.get_collider()
			if not collider is Player:
				var create_at_position = weapon_ray_cast.get_collision_point()
				var normal = weapon_ray_cast.get_collision_normal()
				
				if !owner.has_node(spray.name):
					owner.add_child(spray, true)
				else:
					if owner.name != String(get_tree().get_network_unique_id()):
						spray.global_transform = GameState.get_peer_data(int(owner.name)).mesh_spray_global_transform
						return
						
					if Input.is_action_pressed("ui_left"):
						spray.rotation.z += deg2rad(1)
					elif Input.is_action_pressed("ui_right"):
						spray.rotation.z -= deg2rad(1)
					elif Input.is_action_pressed("ui_up"):						
						spray.rotation.x -= deg2rad(1)
					elif Input.is_action_pressed("ui_down"):						
						spray.rotation.x += deg2rad(1)
					else:
						spray.global_transform.origin = create_at_position
						
					Globals.peer_data.mesh_spray_global_transform = spray.global_transform
									
		else:
			if owner.has_node(spray.name):
				owner.remove_child(spray)

	else:
		if owner.has_node(spray.name):
			owner.remove_child(spray)

