extends ThrowableWeapon
	
func _ready():
	item_name = "Bolt"
	
	var config:ThrowableWeaponConfig = ThrowableWeaponConfig.new()
	config.area_of_effect = $Area
	config.explosion = $Explosion
	config.explosion.emitting = false
	config.explode_delay = 0
	config.explosion_force = 50		
	
	self.setup(config)
	
