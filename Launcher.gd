extends Collectable

class_name Weapon

onready var ammo_spawn_position:Position3D = $AmmoSpawnPosition

func _ready():
	item_name = "Launcher"
	
func shoot(body=null):
	var ammo_instance = preload("res://Bullet.tscn").instance()
	ammo_instance.rotate_x(90)
	ammo_instance.scale = ammo_instance.scale * -0.5
	ammo_spawn_position.add_child(ammo_instance)
	.shoot(ammo_instance)
