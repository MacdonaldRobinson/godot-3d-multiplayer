extends Weapon
class_name WeaponProjectile
func get_class(): return "WeaponProjectile"

var ammo_spawn_position:Position3D

func set_ammo_spawn_position(ammo_spawn_position:Position3D):
	self.ammo_spawn_position = ammo_spawn_position

func primary_action():
	if primary_item_collector and can_use_primary_item():		
		shoot(weapon_ray_cast, primary_item_collector)
		
func secondary_action():
	if secondary_item_collector and can_use_secondary_item():
		shoot(weapon_ray_cast, secondary_item_collector)

func shoot(weapon_ray_cast:RayCast, ammo_collector:AmmoCollector):
	if !can_use_item_collector(ammo_collector):
		return

	var ammo:Ammo = load(ammo_collector.item_tscn_path).instance()
	ammo.weapon_ray_cast = weapon_ray_cast
	ammo.rotation = Vector3.ZERO
	ammo.transform.origin = Vector3.ZERO
	ammo.linear_velocity = Vector3.ZERO
	ammo.angular_velocity = Vector3.ZERO
	ammo.rotation = Vector3.ZERO
	ammo.transform.origin = Vector3.ZERO
	ammo.linear_velocity = Vector3.ZERO
	ammo.angular_velocity = Vector3.ZERO

	if Globals.get_current_scene():
		Globals.get_current_scene().add_child(ammo, true)
		ammo.set_as_toplevel(true)
		ammo.global_transform = ammo_spawn_position.global_transform		
		ammo.apply_central_impulse(-self.global_transform.basis.z * 50)

		decrease_item_collector_amount(ammo_collector)
