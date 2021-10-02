extends Node
class_name SlotsPanel
func get_class(): return "SlotsPanel"

func update_data(new_items:Array):
	_remove_children()
	
	for new_item in new_items:
		if new_item is ItemCollector:
			var new_slot = load("res://ui/slots_panel/slot/Slot.tscn").instance()
			new_slot.update_data(new_item)

			self.add_child(new_slot)

func _remove_children():
	for item in self.get_children():
		self.remove_child(item)
	
