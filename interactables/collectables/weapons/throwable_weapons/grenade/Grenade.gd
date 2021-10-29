extends ThrowableWeapon
class_name Grenade
func get_class(): return "Grenade"

func _ready():
	self.item_name = "Grenade"	
	animation_state = animation_states.magic
	
	initial_collection_amount = -1
	is_sticky_on_throw = false
	
	var config:ThrowableWeaponConfig = ThrowableWeaponConfig.new()
	config.area_of_effect = $Area
	config.explosion = $Explosion
	config.mesh = $MeshInstance
	config.explosion.emitting = false
	config.explode_delay = 2
	config.damage_given = 15
	
	self.setup(config)
