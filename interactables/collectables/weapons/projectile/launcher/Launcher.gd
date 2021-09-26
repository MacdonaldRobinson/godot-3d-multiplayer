extends WeaponProjectile
class_name Launcher

var ammo:Array = []

onready var body:StaticBody = $Body

func _ready():
	var primary_ammo_collector:AmmoCollector = AmmoCollector.new()
	primary_ammo_collector.ammo_name = "Bullet"
	primary_ammo_collector.ammo_node_path = "res://interactables/collectables/weapons/ammos/bullet/Bullet.tscn"
	primary_ammo_collector.current_amount = -1
	primary_ammo_collector.max_capacity = -1	
	
	var secondary_ammo_collector:AmmoCollector = AmmoCollector.new()
	secondary_ammo_collector.ammo_name = "Grenade"
	secondary_ammo_collector.ammo_node_path = "res://interactables/collectables/weapons/ammos/grenade/Grenade.tscn"
	secondary_ammo_collector.current_amount = -1
	secondary_ammo_collector.max_capacity = -1
	
	self.item_name = "Launcher"
	.set_ammo_spawn_position($Body/AmmoSpawnPosition)
	.set_primary_ammo_collector(primary_ammo_collector)
	.set_secondary_ammo_collector(secondary_ammo_collector)
