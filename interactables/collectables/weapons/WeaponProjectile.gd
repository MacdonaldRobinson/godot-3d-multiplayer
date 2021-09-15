extends Weapon
class_name WeaponProjectile

onready var ammo_spawn_position:Position3D = null
var max_capacity = -1
var current_ammo_amount = -1
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
		

func shoot():	
	
	if can_shoot():
		var ammo:Ammo = load(String(ammo_type)).instance()

		ammo.rotation = Vector3.ZERO
		ammo.transform.origin = Vector3.ZERO
		ammo.linear_velocity = Vector3.ZERO
		ammo.angular_velocity = Vector3.ZERO#
		ammo.rotation = Vector3.ZERO
		ammo.transform.origin = Vector3.ZERO
		ammo.linear_velocity = Vector3.ZERO
		ammo.angular_velocity = Vector3.ZERO
		
		ammo.set_as_toplevel(true)
		ammo.apply_central_impulse(-self.global_transform.basis.z * 100)
		
		ammo.set_as_toplevel(true)
		
		ammo.global_transform = ammo_spawn_position.global_transform
		
		if get_tree() and get_tree().current_scene:
			get_tree().current_scene.add_child(ammo)			
			decrease_ammo_amount()
			
