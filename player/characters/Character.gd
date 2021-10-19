extends Node
class_name Character

onready var _animation_tree:AnimationTree = $AnimationTree
onready var _overhead_bars:OverHeadBars = $OverHeadBars
onready var _equipment_bone_attachment:BoneAttachment = $ybot/Armature/Skeleton/EquipmentBoneAttachment
onready var _collision_shape:CollisionShape = $CollisionShape

#var animation_states:AnimationStates = AnimationStates.new()
var movement_directions:MovementDirections = MovementDirections.new()

enum animation_states {
	unequip_crouch = 0,
	unequip_stand = 1
	equip_crouch = 2,
	equip_stand = 3
}

func _ready():
	var parent = get_parent()
	Globals.reparent_node(_collision_shape, parent)
			
func get_equipment_bone_attachment()->BoneAttachment:
	return _equipment_bone_attachment

func get_overhead_bars()->OverHeadBars:
	return _overhead_bars

func get_animation_tree()->AnimationTree:
	return _animation_tree

func get_current_animation_state()->int:
	var current_animation_state = _animation_tree.get(get_animation_state_path())	
	return current_animation_state
	
func get_animation_state_path():
	return "parameters/animation_states/current"

func get_animation_state_name_by_index():
	
	var current_animation_state = get_current_animation_state()
	var current_animation_state_name:String = ""
	
	for entry in animation_states:
		var entry_value = animation_states[entry]
		
		if entry_value == current_animation_state:
			current_animation_state_name = entry
			break
			
	return current_animation_state_name

func get_current_animation_state_blend_path() -> String:
	var current_animation_state_name:String = get_animation_state_name_by_index()
	var path = "parameters/"+current_animation_state_name+"/blend_position"

	return path
	
func is_equipped()->bool:
	if "unequip" in get_current_animation_state_blend_path():
		return false
	elif "equip" in get_current_animation_state_blend_path():
		return true
		
	return false

func is_crouching():
	get_current_animation_state_blend_path().find("crouch")

func get_current_animation_state_blend_amount():
	return _animation_tree.get(get_current_animation_state_blend_path())

func set_current_animation_state_blend_amount(blend_amount:Vector2):
	return _animation_tree.set(get_current_animation_state_blend_path(), blend_amount)

func set_animation_state(new_state:int):
	_animation_tree.set(get_animation_state_path(), new_state)
	
func set_blend_amount(blend_amount:Vector2):
	set_current_animation_state_blend_amount(blend_amount)
	
func get_blend_amount() -> Vector2:
	return get_current_animation_state_blend_amount()
