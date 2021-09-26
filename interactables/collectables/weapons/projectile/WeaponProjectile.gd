extends Weapon
class_name WeaponProjectile

var ammo_spawn_position:Position3D
var primary_ammo_collector:AmmoCollector
var secondary_ammo_collector:AmmoCollector

func set_ammo_spawn_position(ammo_spawn_position:Position3D):
	self.ammo_spawn_position = ammo_spawn_position

func set_primary_ammo_collector(primary_ammmo_collector:AmmoCollector):
	self.primary_ammo_collector = primary_ammmo_collector

func set_secondary_ammo_collector(secondary_ammmo_collector:AmmoCollector):
	self.secondary_ammo_collector = secondary_ammmo_collector

func decrease_ammo_amount(ammo_collector:AmmoCollector):
	if ammo_collector.max_capacity > 0 and ammo_collector.current_amount > 0:
		ammo_collector.current_amount -=1
	
func can_shoot_primary() -> bool:
	if primary_ammo_collector.current_amount > 0 and primary_ammo_collector.max_capacity > 0:
		return true
	else:
		return true
		
func can_shoot_secondary() -> bool:
	if secondary_ammo_collector.current_amount > 0 and secondary_ammo_collector.max_capacity > 0:
		return true
	else:
		return true

func primary_action(weapon_ray_cast:RayCast):
	shoot(weapon_ray_cast, primary_ammo_collector)
		
func secondary_action(weapon_ray_cast:RayCast):
	shoot(weapon_ray_cast, secondary_ammo_collector)
		
func can_shoot(ammo_collector:AmmoCollector):
	if ammo_collector.max_capacity < 0:
		return true
		
	if ammo_collector.max_capacity > 0 and ammo_collector.current_amount > 0:
		return true
		
	return false

func shoot(weapon_ray_cast:RayCast, ammo_collector:AmmoCollector):
	if !can_shoot(ammo_collector):
		return
	
	var ammo_node_path = ammo_collector.ammo_node_path
	
	var ammo:Ammo = load(ammo_node_path).instance()
	ammo.weapon_ray_cast = weapon_ray_cast
	ammo.rotation = Vector3.ZERO
	ammo.transform.origin = Vector3.ZERO
	ammo.linear_velocity = Vector3.ZERO
	ammo.angular_velocity = Vector3.ZERO#
	ammo.rotation = Vector3.ZERO
	ammo.transform.origin = Vector3.ZERO
	ammo.linear_velocity = Vector3.ZERO
	ammo.angular_velocity = Vector3.ZERO
	
	if get_tree() and get_tree().current_scene:
		get_tree().current_scene.add_child(ammo, true)
		ammo.set_as_toplevel(true)
		ammo.global_transform = ammo_spawn_position.global_transform		
		ammo.apply_central_impulse(-self.global_transform.basis.z * 50)
					
		decrease_ammo_amount(ammo_collector)
