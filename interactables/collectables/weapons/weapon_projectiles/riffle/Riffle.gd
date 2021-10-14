extends WeaponProjectile
class_name Riffle
func get_class(): return "Riffle"

var ammo:Array = []
var initial_camera_fov:float = -1
var can_zoom_out:bool = false

var timer:Timer = Timer.new()

func _ready():
	self.can_stack = false	
	
	var primary_item_collector:ItemCollector = ItemCollector.new()
	primary_item_collector.item_name = "Bullet"
	primary_item_collector.item_tscn_path = "res://interactables/collectables/weapons/ammos/bullet/Bullet.tscn"
	primary_item_collector.current_amount = -1
	primary_item_collector.max_capacity = -1	
	
	var secondary_item_collector:ItemCollector = ItemCollector.new()
	secondary_item_collector.item_name = "Grenade"
	secondary_item_collector.item_tscn_path = "res://interactables/collectables/weapons/grenade/Grenade.tscn"
	secondary_item_collector.current_amount = -1
	secondary_item_collector.max_capacity = -1
	
	self.item_name = "Riffle"
	self.set_ammo_spawn_position($AmmoSpawnPosition)
	self.set_primary_item_collector(primary_item_collector)
	self.set_secondary_item_collector(secondary_item_collector)
	
	add_child(timer)
	
	timer.one_shot = true
	timer.autostart = true
	timer.connect("timeout", self, "_on_Timer_timeout")
	

func secondary_action():
	var owner = get_parent().owner
	if owner is Player and owner.current_camera:
		if initial_camera_fov == -1:			
			initial_camera_fov = owner.current_camera.fov
			
		owner.current_camera.fov = lerp(owner.current_camera.fov, 20, 0.1)
		
		timer.start(0.1)
		can_zoom_out = false


func _on_Timer_timeout():
	print("ran")
	var owner = get_parent().owner
	if owner is Player and owner.current_camera:		
		can_zoom_out = true
	

func _process(delta):
	if can_zoom_out:
		var owner = get_parent().owner
		if owner is Player and owner.current_camera:		
			if owner.current_camera.fov < initial_camera_fov-0.1:
				owner.current_camera.fov = lerp(owner.current_camera.fov, initial_camera_fov, 0.1)
				#print("ran _process", owner.current_camera.fov, initial_camera_fov)
			else:
				can_zoom_out = false
