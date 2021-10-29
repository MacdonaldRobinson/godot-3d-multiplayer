extends Node
class_name Character

onready var _animation_tree:AnimationTree = $AnimationTree
onready var _overhead_bars:OverHeadBars = $OverHeadBars
onready var _equipment_bone_attachment:BoneAttachment = $ybot/Armature/Skeleton/EquipmentBoneAttachment
onready var _collision_shape:CollisionShape = $CollisionShape

var animation_states:AnimationStates = AnimationStates.new()
var movement_directions:MovementDirections = MovementDirections.new()

var current_animation_state:String = animation_states.stand

func _ready():
	var parent = get_parent()
	Globals.reparent_node(_collision_shape, parent)
			
func get_equipment_bone_attachment()->BoneAttachment:
	return _equipment_bone_attachment

func get_overhead_bars()->OverHeadBars:
	return _overhead_bars

func get_animation_tree()->AnimationTree:
	return _animation_tree

func get_current_animation_state()->String:
	return current_animation_state
	
func set_animation_state(new_state):
	current_animation_state = new_state	
	get_animation_state_playback().travel(new_state)	

func set_current_animation_blend_position(blend_position:Vector2):
	_animation_tree.set(get_animation_state_path(), blend_position)

func get_current_animation_blend_position():
	return _animation_tree.get(get_animation_state_path())

func is_equipped()->bool:
	var found = current_animation_state.find("equip")
	if found == -1:
		return false
	
	return true
	
func is_crouching()->bool:
	var found = current_animation_state.find("crouch")
	if found == -1:
		return false
		
	return true
	
func get_animation_state_playback()->AnimationNodeStateMachinePlayback:
	return _animation_tree.get(get_animation_state_playback_path())
	
func get_animation_state_playback_path()->String:
	return "parameters/StateMachine/playback"

func get_animation_state_path()->String:
	var path = "parameters/StateMachine/"+current_animation_state+"/blend_position"
	return path
