extends ThrowableWeapon
class_name Grenade
func get_class(): return "Grenade"

func _ready():
	self.item_name = "Grenade"	
	initial_collection_amount = -1
	is_sticky_on_throw = true
	
	var config:ThrowableWeaponConfig = ThrowableWeaponConfig.new()
	config.area_of_effect = $Area
	config.explosion = $Explosion
	config.mesh = $MeshInstance
	config.explosion.emitting = false
	config.explode_delay = 1
	
	self.setup(config)
