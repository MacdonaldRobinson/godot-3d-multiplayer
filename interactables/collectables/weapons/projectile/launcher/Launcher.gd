extends WeaponProjectile
class_name Launcher
func get_class(): return "Launcher"

var ammo:Array = []

func _ready():
	self.can_stack = false
	
	var primary_ammo_collector:AmmoCollector = AmmoCollector.new()
	primary_ammo_collector.item_name = "Bullet"
	primary_ammo_collector.item_tscn_path = "res://interactables/collectables/weapons/ammos/bullet/Bullet.tscn"
	primary_ammo_collector.current_amount = -1
	primary_ammo_collector.max_capacity = -1	
	
	var secondary_ammo_collector:AmmoCollector = AmmoCollector.new()
	secondary_ammo_collector.item_name = "Grenade"
	secondary_ammo_collector.item_tscn_path = "res://interactables/collectables/weapons/ammos/grenade/Grenade.tscn"
	secondary_ammo_collector.current_amount = -1
	secondary_ammo_collector.max_capacity = -1
	
	self.item_name = "Launcher"
	self.set_ammo_spawn_position($AmmoSpawnPosition)
	self.set_primary_item_collector(primary_ammo_collector)
	#.set_secondary_ammo_collector(secondary_ammo_collector)
