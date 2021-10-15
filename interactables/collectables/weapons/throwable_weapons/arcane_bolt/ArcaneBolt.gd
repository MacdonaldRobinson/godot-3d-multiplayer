extends ThrowableWeapon
class_name ArcaneBolt
func get_class(): return "ArcaneBolt"

func _ready():
	self.item_name = "Arcane Bolt"
	self.initial_collection_amount = -1
	self.is_sticky_on_throw = true
	self.is_skill = true
	
	var config:ThrowableWeaponConfig = ThrowableWeaponConfig.new()
	config.area_of_effect = $Area
	config.explosion = $Explosion
	config.explosion.emitting = false
	config.explode_delay = 0
	config.explosion_force = 100
	config.explosion_lifetime = 0.5
	config.damage_given = 50
	
	self.setup(config)
