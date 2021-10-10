extends ThrowableWeapon
class_name Grenade
func get_class(): return "Grenade"

func _ready():
	self.item_name = "Grenade"	
	
	var config:ThrowableWeaponConfig = ThrowableWeaponConfig.new()
	config.area_of_effect = $Area
	config.explosion = $Explosion
	config.mesh = $MeshInstance
	config.explosion.emitting = false
	
	self.setup(config)
