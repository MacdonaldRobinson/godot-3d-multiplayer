extends KinematicBody

class_name Player

var velocity:Vector3 = Vector3.ZERO
var mouse_delta
var current_camera:Camera
var currently_equipped_item:Interactable = null
var collected_items:Array

enum CameraType { FIRST_PERSON, THIRD_PERSON, CUSTOM }

export var gravity = 9.8
export var mouse_sencitivity = 10
export var movement_speed = 20
export var jump_force = 100
export var energy_decrease_amount:float = 1
export var health_decrease_amount:float = 1

export(CameraType) var camera_type
export(NodePath) var custom_camera

onready var cameras = $Cameras
onready var cross_hair = $Cameras/UI/CrossHair
onready var interact_raycast:RayCast = $Cameras/InteractRaycast
onready var camera_raycast:RayCast = $Cameras/CameraRayCast
onready var stats_panel:StatsPanel = $Cameras/UI/StatsPanel
onready var dialog_panel:DialogPanel = $Cameras/UI/DialogPanel
onready var equip_holder:Position3D = $Cameras/WeaponPosition
onready var slots:HBoxContainer = $Cameras/UI/Slots
onready var slot_template:ToolButton = $Cameras/UI/Slots/Template
onready var display_name:Text3D = $Name

func get_class(): return "Player"

func is_network_master():
	if get_tree().network_peer == null:
		return true

	if GameState.peers.size() == 0:
		return true
		
	return .is_network_master()

func _ready():
	if !is_network_master():
		return
		
	collected_items = []
	
	toggle_mouse_capture()
	if camera_type == CameraType.CUSTOM:
		current_camera = get_node(custom_camera)
	elif camera_type == CameraType.FIRST_PERSON:
		current_camera = $Cameras/FirstPersonCamera
	elif camera_type == CameraType.THIRD_PERSON:
		current_camera = $Cameras/ThirdPersonCamera
			
	if current_camera:		
		current_camera.make_current()	

func disable_cameras():
	$Cameras/FirstPersonCamera.current = false
	$Cameras/ThirdPersonCamera.current = false

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
		
	var children = equip_holder.get_children()
	for child in children:
		equip_holder.remove_child(child)
		
	currently_equipped_item = item
	item.transform.origin = Vector3.ZERO
	equip_holder.add_child(currently_equipped_item)
	
func show_message(message:String):
	dialog_panel.visible = true
	dialog_panel.set_text(message)
	
func equip_item_index(index:int):	
	if collected_items.size() > index:
		var item = collected_items[index]
		equip_item(item)		
	else:
		show_message("No item in slot "+String(index))
		
func render_slots():
	print("render_slots", collected_items)	
	for slot in slots.get_children():
		if slot.visible:
			slots.remove_child(slot)
	
	for item in collected_items:
		var new_slot = slot_template.duplicate();
		new_slot.visible = true
		new_slot.text = item.item_name
		slots.add_child(new_slot)

func collect_item(item:Interactable):
	print("ran collect_item", collected_items)
	if item == null:
		return
		
	collected_items.append(item)
	render_slots()

func remove_item(item:Interactable):
	print("ran remove_item", collected_items)
	var index:int = collected_items.find(item)
	collected_items.remove(index)
	render_slots()

func get_stats_panel():
	return stats_panel

func _input(event):
	if !is_network_master():
		return
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		var mouseEvent:InputEventMouseMotion = event as InputEventMouseMotion		
		mouse_delta = event.relative;

func _process(delta):
	if !is_network_master():		
		return	

	if mouse_delta:
		self.rotate_y(deg2rad(-mouse_delta.x * mouse_sencitivity * delta))	
		cameras.rotate_x(deg2rad(-mouse_delta.y * mouse_sencitivity * delta))	
		
	cameras.rotation.x = clamp(cameras.rotation.x, -1.5, 1.5);
	
	mouse_delta = Vector3.ZERO

func _physics_process(delta):	
	var direction = Vector3()
	var new_velocity = velocity
	
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
	
	var current_energy = stats_panel.get_energy()
	var current_health = stats_panel.get_health()
	
	if current_energy > 0 && Input.is_action_pressed("jump"):
		new_velocity.y += jump_force
		stats_panel.set_energy(current_energy-energy_decrease_amount)
		stats_panel.set_health(current_health-health_decrease_amount)
		
	new_velocity = lerp(velocity, new_velocity, 0.1)
	
	if is_network_master():
		velocity = move_and_slide(new_velocity, Vector3.UP)
		Globals.character_data.global_transform = self.global_transform
	
	if !is_network_master():
		return
			
	if dialog_panel != null:
		if interact_raycast.is_colliding():
			if interact_raycast.get_collider() is Interactable:
				var collider = interact_raycast.get_collider() as Interactable

				dialog_panel.visible = true
				dialog_panel.set_text(Globals.get_interact_message())
				
				if Input.is_action_pressed("interact"):
					collider.interact(self)
					if collider is Collectable:
						collider.get_parent().remove_child(collider)
						
						var item = collider as Collectable
						collect_item(collider)
						show_message(Globals.get_collected_message(1, collider))						
						
						if collider is Weapon:
							equip_item(item)
				
		if currently_equipped_item is Weapon and Input.is_action_pressed("shoot"):
			var current_weapon = currently_equipped_item as Weapon;		
			current_weapon.shoot()
		elif currently_equipped_item is Collectable and Input.is_action_just_pressed("shoot"):
			var item = currently_equipped_item as Collectable;		
			item.shoot()
			currently_equipped_item = null
			remove_item(item)
