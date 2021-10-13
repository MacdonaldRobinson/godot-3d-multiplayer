extends WeaponProjectile
class_name Riffle
func get_class(): return "Riffle"

var ammo:Array = []
var initial_camera_fov:float = -1
var can_zoom_out:bool = false

onready var timer:Timer = $Timer

func _ready():
	self.can_stack = false	
	
	var primary_ammo_collector:AmmoCollector = AmmoCollector.new()
	primary_ammo_collector.item_name = "Bullet"
	primary_ammo_collector.item_tscn_path = "res://interactables/collectables/weapons/ammos/bullet/Bullet.tscn"
	primary_ammo_collector.current_amount = -1
	primary_ammo_collector.max_capacity = -1	
	
	var secondary_ammo_collector:AmmoCollector = AmmoCollector.new()
	secondary_ammo_collector.item_name = "Grenade"
	secondary_ammo_collector.item_tscn_path = "res://interactables/collectables/weapons/grenade/Grenade.tscn"
	secondary_ammo_collector.current_amount = -1
	secondary_ammo_collector.max_capacity = -1
	
	self.item_name = "Riffle"
	self.set_ammo_spawn_position($AmmoSpawnPosition)
	self.set_primary_item_collector(primary_ammo_collector)
	#self.set_secondary_item_collector(secondary_ammo_collector)

func secondary_action():
	var owner = get_parent().owner
	if owner is Player and owner.current_camera:
		if initial_camera_fov == -1:			
			initial_camera_fov = owner.current_camera.fov
			
		owner.current_camera.fov = lerp(owner.current_camera.fov, 20, 0.1)
		
		timer.start(0.1)


func _on_Timer_timeout():
	print("ran")
	var owner = get_parent().owner
	if owner is Player and owner.current_camera:		
		can_zoom_out = true
	

func _process(delta):
	if can_zoom_out:
		var owner = get_parent().owner
		if owner is Player and owner.current_camera:		
			if owner.current_camera.fov != initial_camera_fov:
				owner.current_camera.fov = lerp(owner.current_camera.fov, initial_camera_fov, 0.1)
