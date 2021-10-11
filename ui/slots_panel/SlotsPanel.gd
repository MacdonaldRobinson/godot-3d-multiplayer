extends Node
class_name SlotsPanel
func get_class(): return "SlotsPanel"

onready var slots = $Slots

func _ready():
	_remove_children()

func update_data(item_collectors:ItemCollectors):
	var new_items:Array = item_collectors.get_all()
	
	if new_items.size() == 0:
		_remove_children()
		
	for new_item in new_items:
		if new_item is ItemCollector:
			var slot = update_slot(new_item)			
			if !slot:
				var new_slot = load("res://ui/slots_panel/slot/Slot.tscn").instance()
				new_slot.set_slot_index(slots.get_child_count()-1)
				new_slot.update_data(new_item)

				slots.add_child(new_slot)
				

	for slot in slots.get_children():
		if slot is Slot:
			if new_items.find(slot.current_item_collector) == -1:
				slots.remove_child(slot)
				
					
		
func update_slot(item_collector:ItemCollector) -> Slot:
	var index = -1
	for slot in slots.get_children():
		if slot is Slot:
			index+=1
			if !slot.current_item_collector:
				continue
				
			if slot.current_item_collector.item_name == item_collector.item_name:
				slot.set_slot_index(index)
				slot.update_data(item_collector)
				return slot
				
	return null


func _remove_children():
	var remove_slots = slots.get_children()
	for item in remove_slots:
		slots.remove_child(item)
	
