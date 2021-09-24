extends Weapon
class_name Creator

var item = preload("res://interactables/collectables/weapons/creator/structures/mesh_spray/MeshSpray.tscn")
var spray:MeshSpray = item.instance()

func _ready():
	self.item_name = "Creator"
	self.max_capacity = -1
	self.current_ammo_amount = -1	
	spray.name = "spray"
	
	var material:SpatialMaterial = spray.get_node("MeshInstance").mesh.material.duplicate() as SpatialMaterial
	var collision_shape:CollisionShape = spray.get_node("CollisionShape") as CollisionShape
	
	collision_shape.disabled = true
	
	material.albedo_color = Color(1, 0, 0, 0.85)	
	material.flags_transparent = true

	spray.get_node("MeshInstance").material_override = material
	
	
func shoot(weapon_ray_cast:RayCast):
	if weapon_ray_cast.is_colliding():
		var collider = weapon_ray_cast.get_collider()
		if not collider is Player:
			var create_at_position = weapon_ray_cast.get_collision_point()
			var normal = weapon_ray_cast.get_collision_normal()
			
			var new_item:Spatial = item.instance()
			
			collider.add_child(new_item)
			new_item.global_transform = spray.global_transform

func _process(delta):
	var parent = get_parent()	
	var owner = parent.get_owner()
	if owner is Player:
		var weapon_ray_cast = owner._weapon_raycast
		if weapon_ray_cast.is_colliding():
			var collider = weapon_ray_cast.get_collider()
			if not collider is Player:
				var create_at_position = weapon_ray_cast.get_collision_point()
				var normal = weapon_ray_cast.get_collision_normal()
				
				if !owner.has_node(spray.name):					
					owner.add_child(spray)
					spray.rotation = owner.rotation
				else:
					if Input.is_action_pressed("ui_left"):
						spray.rotation.y -= deg2rad(1)
					elif Input.is_action_pressed("ui_right"):
						spray.rotation.y += deg2rad(1)
					elif Input.is_action_pressed("ui_up"):
						spray.rotation.x -= deg2rad(1)
					elif Input.is_action_pressed("ui_down"):
						spray.rotation.x += deg2rad(1)
					else:
						spray.global_transform.origin = create_at_position
		else:
			if owner.has_node(spray.name):
				owner.remove_child(spray)
			
	else:
		if owner.has_node(spray.name):
			owner.remove_child(spray)

	if is_network_master():
		Globals.peer_data.mesh_spray_global_transform = spray.global_transform		
