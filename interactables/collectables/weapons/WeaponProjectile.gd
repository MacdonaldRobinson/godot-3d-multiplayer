extends Weapon
class_name WeaponProjectile

onready var ammo_spawn_position:Position3D = null
var ammo_type:NodePath

func _ready():
	pass

func set_ammo_spawn_position(ammo_spawn_position:Position3D):
	self.ammo_spawn_position = ammo_spawn_position

func set_ammo_type(ammo:NodePath):
	ammo_type = ammo
	
func can_shoot() -> bool:
	if current_ammo_amount == -1:
		return true

	if current_ammo_amount > 0:
		return true
		
	return false

func decrease_ammo_amount():
	if not current_ammo_amount < 0:
		current_ammo_amount -= 1

func shoot(weapon_ray_cast:RayCast):
	if can_shoot():
		var ammo:Ammo = load(String(ammo_type)).instance()
				
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
			get_tree().current_scene.add_child(ammo)
			ammo.set_as_toplevel(true)
			ammo.global_transform = ammo_spawn_position.global_transform		
			ammo.apply_central_impulse(-self.global_transform.basis.z * 50)
					
			decrease_ammo_amount()
