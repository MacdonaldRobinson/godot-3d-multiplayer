extends Interactable
class_name Collectable
func get_class(): return "Collectable"

var can_stack = true
var primary_item_collector:ItemCollector
var secondary_item_collector:ItemCollector
var weapon_ray_cast:RayCast
var initial_collection_amount:int = 1
var is_sticky_on_throw:bool = false

signal was_throw_impact

func set_weapon_ray_cast(weapon_ray_cast:RayCast):
	self.weapon_ray_cast = weapon_ray_cast

func set_primary_item_collector(primary_item_collector:ItemCollector):
	self.primary_item_collector = primary_item_collector

func set_secondary_item_collector(secondary_item_collector:ItemCollector):
	self.secondary_item_collector = secondary_item_collector

func decrease_item_collector_amount(item_collector:ItemCollector) ->ItemCollector:
	if item_collector.current_amount > 0:
		item_collector.current_amount -=1
		
	return item_collector
	
func can_use_item_collector(item_collector:ItemCollector) -> bool:
	if item_collector.current_amount != 0:
		return true
	else:
		return false
	
func can_use_primary_item() -> bool:
	return can_use_item_collector(primary_item_collector)
		
func can_use_secondary_item() -> bool:
	return can_use_item_collector(secondary_item_collector)

func primary_action():	
	decrease_item_collector_amount(primary_item_collector)
	
func secondary_action():	
	decrease_item_collector_amount(secondary_item_collector)

func _body_entered(body:Node):
	if body != self.get_parent().owner:
		emit_signal("was_throw_impact", body)
	
func throw_self(force:int = 50):	
	if get_parent() and get_parent().owner:
		var owner = get_parent().owner
		var found = owner.find_in_collected_items(self)
		if found:
			self.set_primary_item_collector(found)			
			var item:Collectable = self
			var self_transform = self.global_transform
			
			item.get_parent().remove_child(item)
			
			Globals.get_current_scene().add_child(item, true)						
			
			item.global_transform = self_transform
			
			if !item.is_connected("body_entered", item, "_body_entered"):
				item.connect("body_entered", item, "_body_entered")
			#item.was_thrown = true
			
			var collision_exceptions:Array = []
#			collision_exceptions.append(get_parent())
#			collision_exceptions.append(owner)

			
			item.enable_collisions(collision_exceptions)
			
			item.apply_central_impulse(-owner._equip_holder.global_transform.basis.z * force)
			
			owner.currently_equipped_item = null
			
			self.decrease_item_collector_amount(primary_item_collector)
			
			if !can_use_item_collector(found):				
				owner.remove_from_collected_items(self)
