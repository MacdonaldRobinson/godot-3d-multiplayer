extends WeaponProjectile
class_name Launcher

var ammo:Array = []

func _ready():
	self.item_name = "Launcher"
	self.scale = self.scale / 2 
	.set_ammo_spawn_position($AmmoSpawnPosition)
	.set_ammo_type("res://interactables/collectables/weapons/ammos/bullet/Bullet.tscn")
