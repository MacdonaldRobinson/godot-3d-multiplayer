extends Node
class_name Character

var _animation_tree:AnimationTree
var _overhead_bars:OverHeadBars

enum CROUCH_WALK_RUN {
	CROUCH = -1,
	WALK = 0,
	RUN = 1
}

var MOVEMENT_DIRECTIONS:MovementDirections = MovementDirections.new()

var current_state:int

func _ready():
	var parent = get_parent()
	
	for child in get_children():
		if child is CollisionShape:
			Globals.reparent_node(child, parent)
			
	for child in get_children():
		if child is AnimationTree:
			_animation_tree = child				
			break
			
	for child in get_children():
		if child is OverHeadBars:
			_overhead_bars = child
			break			
			
func _process(delta):
	var current_amount = get_crouch_walk_run_blend_amount()	
	var str_current_amount = var2str(current_amount)
	var str_current_state = var2str(float(current_state))
	
	if str_current_amount != str_current_state:
		var lerp_state = lerp(current_amount, current_state, 0.1)
		_animation_tree.set(get_crouch_walk_run_path(), lerp_state)
			
func get_overhead_bars()->OverHeadBars:
	return _overhead_bars

func get_animation_player()->AnimationTree:
	return _animation_tree

func get_crouch_walk_run_path():
	return "parameters/crouch_walk_run/blend_amount"

func get_crouch_path():
	return "parameters/crouch/blend_position"

func get_walk_path():
	return "parameters/walk/blend_position"
	
func get_run_path():
	return "parameters/run/blend_position"
		
func get_crouch_walk_run_blend_amount()->float:
	return _animation_tree.get(get_crouch_walk_run_path())
	
func get_crouch_blend_amount()->Vector2:	
	return _animation_tree.get(get_crouch_path())
	
func get_walk_blend_amount()->Vector2:
	return _animation_tree.get(get_walk_path())
	
func get_run_blend_amount()->Vector2:
	return _animation_tree.get(get_run_path())
		
func set_crouch_walk_run_blend_amount(blend_amount:int):	
	current_state = blend_amount
	
func set_crouch_blend_amount(blend_amount:Vector2):	
	_animation_tree.set(get_crouch_path(), blend_amount)
	
func set_walk_blend_amount(blend_amount:Vector2):
	_animation_tree.set(get_walk_path(), blend_amount)
	
func set_run_blend_amount(blend_amount:Vector2):
	_animation_tree.set(get_run_path(), blend_amount)
	
func is_crouching()->bool:
	match current_state:
		CROUCH_WALK_RUN.CROUCH:
			return true
			
	return false
				
func set_blend_amount(blend_amount:Vector2):
	match current_state:
		CROUCH_WALK_RUN.CROUCH:
			set_crouch_blend_amount(blend_amount)
		CROUCH_WALK_RUN.WALK:
			set_walk_blend_amount(blend_amount)
		CROUCH_WALK_RUN.RUN:
			set_run_blend_amount(blend_amount)
	
func get_blend_amount() -> Vector2:
	match current_state:
		CROUCH_WALK_RUN.CROUCH:
			return get_crouch_blend_amount()
		CROUCH_WALK_RUN.WALK:
			return get_walk_blend_amount()
		CROUCH_WALK_RUN.RUN:
			return get_run_blend_amount()
			
	return Vector2.ZERO
