extends KinematicBody

class_name Player

enum AnimationState {
	WALK = 0,
	DEAD = 1
}

var velocity:Vector3 = Vector3.ZERO
var mouse_delta
var current_camera:Camera
var currently_equipped_item:Interactable = null
var collected_items:Array
	
export var gravity = 9.8
export var mouse_sencitivity = 10
export var movement_speed = 10
export var jump_force = 50
export var energy_decrease_amount:float = 1
export var health_decrease_amount:float = 1
export var camera_zoom_ticks:float = 1

export var health:int = 100 setget _set_health
export var energy:int = 100 setget _set_energy
export var player_name:String = "Player" setget _set_player_name

onready var _camera_pivot = $CameraPivot
onready var _main_camera:Camera = $CameraPivot/MainCamera

onready var _cross_hair = $ScreenOverlays/CrossHair
onready var _interact_raycast:RayCast = $CameraPivot/MainCamera/InteractRayCast
onready var _weapon_raycast:RayCast = $CameraPivot/MainCamera/WeaponRayCast
onready var _screen_overlay:ScreenOverlay = $ScreenOverlays
onready var _equip_holder:Position3D = $CameraPivot/MainCamera/EquipPosition
onready var _over_head_name:Text3D = $Name
onready var _health_bar:Progress3D = $HealthBar

func get_class(): return "Player"

func _set_health(new_value):
	if new_value < 0 or new_value > 100:
		return
		
	health = new_value	
	_health_bar.value = new_value
	
	if health == 0:
		set_current_animation_state(AnimationState.DEAD)
	else:
		set_current_animation_state(AnimationState.WALK)
		
	if is_network_master():
		sync_self_property("health", new_value)
		
func _set_energy(new_value):
	if new_value < 0 or new_value > 100:
		return

	energy = new_value	
	
	if is_network_master():
		sync_self_property("energy", new_value)
	
func _set_player_name(new_name):
	player_name = new_name
	_over_head_name.set_text(new_name)
	
	if is_network_master():
		sync_self_property("player_name", new_name)

func is_network_master():
	if get_tree().network_peer == null:
		return true

	if GameState.get_peers().size() == 0:
		return true
		
	return .is_network_master()

func _ready():		
	var peer_id = get_tree().get_network_unique_id()
	var peer_data = GameState.get_peer_data(peer_id)
		
	_set_player_name(peer_data.peer_name)
	
	if !is_network_master():		
		_main_camera.current = false
		_screen_overlay.hide()
		return
	
	
	collected_items = []	
	current_camera = _main_camera
	
	current_camera.make_current()	
		
func _get_interact_raycast() -> RayCast:
	return current_camera.get_node("RayCast") as RayCast

func disable_cameras():	
	if _main_camera:
		_main_camera.current = false
	
	if current_camera and current_camera.current:
		current_camera.current = false


func equip_item(item:Interactable):
	if item == null or item == currently_equipped_item:
		return
		
	un_equip()
		
	currently_equipped_item = item

	for child in item.get_children():
		if child is CollisionShape:
			child.disabled = true
		else:
			for c in child.get_children():
				if c is CollisionShape:
					c.disabled = true
		
	
	item.transform.origin = Vector3.ZERO	
	
	_equip_holder.add_child(currently_equipped_item)
	
	if is_network_master():
		Globals.peer_data.currently_equipped_item_tscn = currently_equipped_item.filename		

func un_equip():
	var children = _equip_holder.get_children()
	
	for child in children:
		_equip_holder.remove_child(child)
		
	if has_node("spray"):
		var spray = get_node("spray")
		remove_child(spray)

func equip_item_index(index:int):	
	if collected_items.size() > index:
		var item = collected_items[index]
		equip_item(item)		
		
#func render_slots():
#	print("render_slots", collected_items)	
#	for _slot in _slots.get_children():
#		if _slot.visible:
#			_slots.remove_child(_slot)
#
#	for item in collected_items:
#		var new_slot = _slot_template.duplicate();
#		new_slot.visible = true
#		new_slot.text = item.item_name
#		_slots.add_child(new_slot)

func collect_item(item:Collectable):
	print("ran collect_item", item)
	if item == null:
		return
		
	var body = item.get_child(0)
		
	for child in body.get_children():
		if child is CollisionShape:
			(child as CollisionShape).disabled = true
	
	collected_items.append(item)

func remove_item(item:Interactable):
	print("ran remove_item", collected_items)
	var index:int = collected_items.find(item)
	collected_items.remove(index)
	
func _input(event):	
	if !is_network_master():
		return
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		mouse_delta = event.relative;
		
	if event is InputEventMouseButton:
		var event_mouse_button:InputEventMouseButton = event as InputEventMouseButton
		var camera_zoom = _camera_pivot.transform.origin.z
		
	if Input.is_action_just_pressed("toggle_mouse_capture"):
		Globals.toggle_mouse_capture()		
		
		
var walk_blend_direction:Vector2 = Vector2.ZERO

func handle_walk_animations():
	var new_direction = Vector2.ZERO
	
	if Input.is_action_pressed("backward"):
		new_direction = Vector2(-1,0)		
	elif Input.is_action_pressed("forward"):		
		new_direction = Vector2(1,0)
	if Input.is_action_pressed("left"):
		new_direction = Vector2(0,1)
	elif Input.is_action_pressed("right"):
		new_direction = Vector2(0,-1)
		
	walk_blend_direction = lerp(walk_blend_direction, new_direction, 0.1)	
	play_animation("parameters/walk_direction/blend_position", walk_blend_direction)
	
func play_animation(animation_path:String, animation_value, set_in_peer_data:bool = true):
	#_anim_tree.set(animation_path, animation_value)
	
	if set_in_peer_data:
		Globals.peer_data.animations[animation_path] = animation_value		
	
func set_current_animation_state(state):
	play_animation("parameters/state/current", state, false)
		
#func set_from_peer_data(peer_data:PeerData):
#	_set_player_name(peer_data.peer_name)
#
#	if is_network_master():
#		return
#
#	_set_health(peer_data.health)
#	_set_energy(peer_data.energy)
#
#	global_transform = peer_data.global_transform	
#	_camera_pivot.rotation = peer_data.camera_pivot_rotation
#	_equip_holder.global_transform = peer_data.equip_holder_transform
#
#	if peer_data.remote_method_call:
#		call(peer_data.remote_method_call)
#
#	if !peer_data.currently_equipped_item_tscn.empty():			
#		var path_to_tscn = peer_data.currently_equipped_item_tscn
#
#		if currently_equipped_item == null:
#			var instance:Node = load(path_to_tscn).instance()
#			equip_item(instance)
#
#		else:
#			if currently_equipped_item.filename != path_to_tscn:
#				var instance = load(path_to_tscn).instance()
#				equip_item(instance)		
#
#	else:
#		if currently_equipped_item != null:
#			un_equip()
#
##	for animation_key in peer_data.animations:
##		play_animation(animation_key, peer_data.animations[animation_key])
##
#	if currently_equipped_item and "spray" in currently_equipped_item:
#		currently_equipped_item.spray.global_transform = peer_data.mesh_spray_global_transform		
#
remotesync func equipped_item_primary_action():
	if currently_equipped_item is Weapon:		
		currently_equipped_item.primary_action(_weapon_raycast)
	
remotesync func equipped_item_secondary_action():
	if currently_equipped_item is Weapon:
		currently_equipped_item.secondary_action(_weapon_raycast)
	
remotesync func interact():
	if !_interact_raycast.is_colliding():
		return
		
	var collider = _interact_raycast.get_collider().get_parent()
	
	if collider:
		collider.interact(self)
		if collider is Collectable:
			collider.get_parent().remove_child(collider)
			
			var item = collider as Collectable
			collect_item(collider)
			
			if collider is Weapon:
				equip_item(item)

func look_at_weapon_ray_cast():
	if _weapon_raycast.is_colliding():
		var collider = _weapon_raycast.get_collider()
		
		var new_transform = Globals.look_at(_equip_holder.global_transform, _weapon_raycast.get_collision_point())
		_equip_holder.global_transform = new_transform
	else:
		_equip_holder.rotation = _equip_holder.rotation.linear_interpolate(Vector3.ZERO, 0.1)		
		
	Globals.peer_data.equip_holder_transform = _equip_holder.global_transform

func sync_camera_pivot_property(property_name:String, new_property_value):
	rpc("_sync_camera_pivot_property", property_name, var2str(new_property_value))

func sync_self_property(property_name:String, new_property_value):
	rpc("_sync_self_property", property_name, var2str(new_property_value))

remote func _sync_camera_pivot_property(property_name:String, new_property_value:String):
	_camera_pivot.set(property_name, str2var(new_property_value))

remote func _sync_self_property(property_name:String, new_property_value:String):
	set(property_name, str2var(new_property_value))

func _physics_process(delta):	
	if !is_network_master():
		return	
		
	var direction = Vector3()
	var new_velocity = velocity
	
	handle_walk_animations()
	if Globals.is_mouse_captured():
		if Input.is_action_pressed("forward"):		
			direction -= transform.basis.z		
		elif Input.is_action_pressed("backward"):		
			direction += transform.basis.z
		if Input.is_action_pressed("left"):		
			direction -= transform.basis.x
		elif Input.is_action_pressed("right"):
			direction += transform.basis.x
			
		if Input.is_action_just_pressed("slot1"):
			equip_item_index(0)
		if Input.is_action_just_pressed("slot2"):
			equip_item_index(1)

#	if Input.is_action_just_pressed("ui_cancel"):
#		get_tree().quit()	
		
		
	direction = direction.normalized()
		
	new_velocity = direction * movement_speed
	
	if !is_on_floor():
		new_velocity.y -= gravity
	
	if Globals.is_mouse_captured():
		if self.energy > 0 && Input.is_action_pressed("jump"):
			new_velocity.y += jump_force
			self.energy = self.energy-energy_decrease_amount

	new_velocity = lerp(velocity, new_velocity, 0.1)
	
	velocity = move_and_slide(new_velocity, Vector3.UP)	
	
	sync_self_property("global_transform", self.global_transform)
	
	var old_camera_pivot_rotation = var2str(_camera_pivot.rotation)
	var old_self_rotation = var2str(self.rotation)
	if mouse_delta:
		self.rotate_y(deg2rad(-mouse_delta.x * mouse_sencitivity * delta))	
		_camera_pivot.rotate_x(deg2rad(-mouse_delta.y * mouse_sencitivity * delta))	

	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -1.5, 1.5);
	
	var new_camera_pivot_rotation = var2str(_camera_pivot.rotation)
	var new_self_rotation = var2str(self.rotation)	
	
	sync_camera_pivot_property("global_transform", _camera_pivot.global_transform)	

	mouse_delta = Vector3.ZERO
	
	if Globals.is_mouse_captured():
		if currently_equipped_item is Weapon and Input.is_action_pressed("primary_action"):			
			rpc("equipped_item_primary_action")
		elif currently_equipped_item is Weapon and Input.is_action_pressed("secondary_action"):			
			rpc("equipped_item_secondary_action")

	look_at_weapon_ray_cast()
	
	if _weapon_raycast.is_colliding():
		var collider = _weapon_raycast.get_collider()		
	
	if _interact_raycast.is_colliding():
		
		var collider = _interact_raycast.get_collider()
		var collider_parent = collider.get_parent()

		if collider_parent is Interactable:			
			if Input.is_action_pressed("interact"):
				rpc("interact")

	_screen_overlay.update_data(player_name, 
			health, 
			energy,
			currently_equipped_item, 
			collected_items)
