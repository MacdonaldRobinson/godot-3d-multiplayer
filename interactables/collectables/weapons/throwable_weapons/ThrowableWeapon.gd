extends Weapon
class_name ThrowableWeapon
func get_class(): return "ThrowableWeapon"

var _config:ThrowableWeaponConfig = ThrowableWeaponConfig.new()

func _ready():
	item_name = "Throwable Weapon"	

func setup(config:ThrowableWeaponConfig):
	_config = config
	
	if !self.is_connected("was_throw_impact", self, "_was_throw_impact"):
		self.connect("was_throw_impact", self, "_was_throw_impact")
	
func start_explosion_sequence():
	if self.is_sticky_on_throw:
		self.mode = RigidBody.MODE_KINEMATIC

	yield(get_tree().create_timer(_config.explode_delay), "timeout")

	print("explode")
	_config.explosion.emitting = true
	_config.explosion.one_shot = true
	
	if _config.mesh:
		_config.mesh.visible = false	
	
	var bodies = _config.area_of_effect.get_overlapping_bodies()

	for body in bodies:
		if body is Interactable:
			var direction = (self.global_transform.origin - body.global_transform.origin).normalized()
			
			if body != self:
				body.apply_central_impulse(-direction * _config.explosion_force)		
							
		if body.has_method("take_damage"):
			body.take_damage(_config.damage_given)
				
	yield(get_tree().create_timer(_config.explosion_lifetime), "timeout")
	queue_free()
	
func _was_throw_impact(body:Node):
	print("_was_throw_impact", body)
	start_explosion_sequence()
	disconnect("was_throw_impact", self, "_was_throw_impact")

func primary_action():
	print("ran primary_action")	
	self.throw_self(50)
	
func secondary_action():
	print("ran secondary_action")	
	self.throw_self(1)
