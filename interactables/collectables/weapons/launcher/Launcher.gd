extends WeaponProjectile
class_name Launcher

var ammo:Array = []

onready var body:StaticBody = $Body

func _ready():
	self.item_name = "Launcher"
	self.max_capacity = -1
	self.current_ammo_amount = -1
	.set_ammo_spawn_position($Body/AmmoSpawnPosition)
	.set_ammo_type("res://interactables/collectables/weapons/ammos/bullet/Bullet.tscn")
