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
export var jump_force = 100
export var energy_decrease_amount:float = 1
export var health_decrease_amount:float = 1
export var camera_zoom_ticks:float = 1

export var health:int = 100 setget _set_health
export var energy:int = 100 setget _set_energy
export var display_name:String = "Player" setget _set_display_name

onready var _camera_pivot = $CameraPivot
onready var _main_camera:Camera = $CameraPivot/MainCamera

onready var _cross_hair = $ScreenOverlays/CrossHair
onready var _interact_raycast:RayCast = $CameraPivot/MainCamera/InteractRayCast
onready var _weapon_raycast:RayCast = $CameraPivot/MainCamera/WeaponRayCast
onready var _stats_panel:StatsPanel = $ScreenOverlays/StatsPanel
onready var _dialog_panel:DialogPanel = $ScreenOverlays/DialogPanel
onready var _equip_holder:Position3D = $CameraPivot/MainCamera/EquipPosition
onready var _slots:HBoxContainer = $ScreenOverlays/Slots
onready var _slot_template:ToolButton = $ScreenOverlays/Slots/Template
onready var _display_name:Text3D = $Name
onready var _anim_tree:AnimationTree = $Character/AnimationTree
onready var _health_bar:Progress3D = $HealthBar

func get_class(): return "Player"

func _set_health(new_value):
	if new_value < 0 or new_value > 100:
		return
		
	health = new_value
	_stats_panel.health = health
	_health_bar.value = health
	
	if health == 0:
		set_current_animation_state(AnimationState.DEAD)
	else:
		set_current_animation_state(AnimationState.WALK)
	
	if is_network_master():
		Globals.peer_data.health = health
		
func _set_energy(new_value):
	if new_value < 0 or new_value > 100:
		return

	energy = new_value	
	_stats_panel.energy = energy	
	
	if is_network_master():
		Globals.peer_data.health = health
	
func _set_display_name(value):
	_display_name.set_text(value)	

func is_network_master():
	if get_tree().network_peer == null:
		return true

	if GameState.get_peers().size() == 0:
		return true
		
	return .is_network_master()

func _ready():		
	if !is_network_master():		
		return
		
	toggle_mouse_capture()
	
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

func toggle_mouse_capture():
	if !is_network_master():
		return
		
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func equip_item(item:Interactable):
	if item == null or item == currently_equipped_item:
		return
		
	un_equip()
		
	currently_equipped_item = item
	item.transform.origin = Vector3.ZERO
	_equip_holder.add_child(currently_equipped_item)
	
	Globals.peer_data.currently_equipped_item_tscn = currently_equipped_item.filename
	print("equiped ->", currently_equipped_item.filename )

func un_equip():
	var children = _equip_holder.get_children()
	
	for child in children:
		_equip_holder.remove_child(child)

func show_message(message:String):
	_dialog_panel.visible = true
	_dialog_panel.set_text(message)
	
func equip_item_index(index:int):	
	if collected_items.size() > index:
		var item = collected_items[index]
		equip_item(item)		
	else:
		show_message("No item in slot "+String(index))
		
func render_slots():
	print("render_slots", collected_items)	
	for _slot in _slots.get_children():
		if _slot.visible:
			_slots.remove_child(_slot)
	
	for item in collected_items:
		var new_slot = _slot_template.duplicate();
		new_slot.visible = true
		new_slot.text = item.item_name
		_slots.add_child(new_slot)

func collect_item(item:Interactable):
	print("ran collect_item", item)
	if item == null:
		return
		
	var body = item.get_child(0)
		
	for child in body.get_children():
		if child is CollisionShape:
			(child as CollisionShape).disabled = true
	
	collected_items.append(item)
	render_slots()

func remove_item(item:Interactable):
	print("ran remove_item", collected_items)
	var index:int = collected_items.find(item)
	collected_items.remove(index)
	render_slots()
	
func _input(event):	
	if !is_network_master():
		return
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:		
		mouse_delta = event.relative;
		
	if event is InputEventMouseButton:
		var event_mouse_button:InputEventMouseButton = event as InputEventMouseButton
		var camera_zoom = _camera_pivot.transform.origin.z
		
#		if event_mouse_button.button_index == BUTTON_WHEEL_UP:
#			camera_zoom = camera_zoom - camera_zoom_ticks
#		elif event_mouse_button.button_index == BUTTON_WHEEL_DOWN:
#			camera_zoom = camera_zoom + camera_zoom_ticks
#
#		camera_zoom = lerp(_camera_pivot.transform.origin.z, camera_zoom, 0.1)
#
#		_camera_pivot.transform.origin.z = camera_zoom

		
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
	_anim_tree.set(animation_path, animation_value)
	
	if set_in_peer_data:
		Globals.peer_data.animations[animation_path] = animation_value
		Globals.peer_data.camera_pivot_transform =_camera_pivot.transform
	
func set_current_animation_state(state):
	play_animation("parameters/state/current", state, false)
		
func shoot():
	var current_weapon = currently_equipped_item as Weapon
	current_weapon.shoot()
	
func set_from_peer_data(peer_data:PeerData):
	if is_network_master():
		return
		
	health = peer_data.health
	energy = peer_data.energy
	global_transform = peer_data.global_transform
	_camera_pivot.transform = peer_data.camera_pivot_transform
	display_name = peer_data.display_name
	
	if peer_data.remote_method_call:
		call(peer_data.remote_method_call)

	if !peer_data.currently_equipped_item_tscn.empty():			
		var path_to_tscn = peer_data.currently_equipped_item_tscn

		if currently_equipped_item == null:
			var instance = load(path_to_tscn).instance()
			equip_item(instance)
		else:
			if currently_equipped_item.filename != path_to_tscn:
				var instance = load(path_to_tscn).instance()
				equip_item(instance)		
	else:
		if currently_equipped_item != null:
			un_equip()

	for animation_key in peer_data.animations:
		play_animation(animation_key, peer_data.animations[animation_key])
	
func interact():
	var collider = _interact_raycast.get_collider().get_parent()
	
	if collider:
		collider.interact(self)
		if collider is Collectable:
			collider.get_parent().remove_child(collider)
			
			var item = collider as Collectable
			collect_item(collider)
			show_message(Globals.get_collected_message(1, collider))
			
			if collider is Weapon:
				equip_item(item)
	
func _physics_process(delta):
	if !is_network_master():
		return	
	
	Globals.peer_data.remote_method_call = ""
	
	var direction = Vector3()
	var new_velocity = velocity
	
	handle_walk_animations()
	
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

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()	
		
	if Input.is_action_just_pressed("toggle_mouse_capture"):
		toggle_mouse_capture()	
		
	direction = direction.normalized()
		
	new_velocity = direction * movement_speed
	
	if !is_on_floor():
		new_velocity.y -= gravity
	
	if self.energy > 0 && Input.is_action_pressed("jump"):
		new_velocity.y += jump_force
		self.energy = self.energy-energy_decrease_amount
			
		
	new_velocity = lerp(velocity, new_velocity, 0.1)
	
	velocity = move_and_slide(new_velocity, Vector3.UP)		
	Globals.peer_data.global_transform = self.global_transform
	
	if mouse_delta:
		self.rotate_y(deg2rad(-mouse_delta.x * mouse_sencitivity * delta))	
		_camera_pivot.rotate_x(deg2rad(-mouse_delta.y * mouse_sencitivity * delta))	

	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -1.5, 1.5);

	mouse_delta = Vector3.ZERO
	
	if currently_equipped_item is Weapon and Input.is_action_pressed("shoot"):
		shoot()
		Globals.peer_data.remote_method_call = "shoot"
	
	if _weapon_raycast.is_colliding():
		var collider = _weapon_raycast.get_collider()
		
		var new_transform = Globals.look_at(_equip_holder.global_transform, _weapon_raycast.get_collision_point())
		_equip_holder.global_transform = new_transform
	else:
		_equip_holder.rotation = _equip_holder.rotation.linear_interpolate(Vector3.ZERO, 0.1)
		
	if _dialog_panel != null:
		
		if _interact_raycast.is_colliding():
			
			var collider = _interact_raycast.get_collider()
			var collider_parent = collider.get_parent()
			
			
			
			if collider_parent is Interactable:
								
				_dialog_panel.visible = true
				_dialog_panel.set_text(Globals.get_interact_message())
				
				if Input.is_action_pressed("interact"):
					interact()
					#Globals.peer_data.remote_method_call = "interact"
