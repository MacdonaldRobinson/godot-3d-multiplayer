extends Weapon
class_name ThrowableWeapon
func get_class(): return "ThrowableWeapon"

var _throwable_weapon_config:ThrowableWeaponConfig = ThrowableWeaponConfig.new()

func _ready():
	item_name = "Throwable Weapon"	

func setup(throwable_weapon_config:ThrowableWeaponConfig):
	_throwable_weapon_config = throwable_weapon_config
	_throwable_weapon_config.area_of_effect.connect("body_entered", self, "_on_area_of_effect_body_entered")
	
func explode():
	print("explode")
	_throwable_weapon_config.explosion.emitting = true
	_throwable_weapon_config.explosion.one_shot = true
	
	if _throwable_weapon_config.mesh:
		_throwable_weapon_config.mesh.visible = false	
	
	var bodies = _throwable_weapon_config.area_of_effect.get_overlapping_bodies()

	for body in bodies:
		if body is RigidBody:
			var direction = (self.global_transform.origin - body.global_transform.origin).normalized()
			
			if body != self:
				body.apply_central_impulse(-direction * _throwable_weapon_config.explosion_force)		
		
		if body is Player:
			body.health -= _throwable_weapon_config.damage_given
				
	yield(get_tree().create_timer(_throwable_weapon_config.explosion_lifetime), "timeout")
	queue_free()

func primary_action():
	print("ran granade primary_action")	
	self.throw_self(50)
	
func secondary_action():
	print("ran granade secondary_action")	
	self.throw_self(1)

func _on_area_of_effect_body_entered(body):
	if was_thrown:		
		was_thrown = false
		yield(get_tree().create_timer(_throwable_weapon_config.explode_delay), "timeout")
		explode()
