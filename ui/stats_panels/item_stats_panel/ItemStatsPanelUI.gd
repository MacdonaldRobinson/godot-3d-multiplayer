extends Control
class_name ItemStatsPanelUI

onready var primary_item_collector_holder:Control = $ItemStatsPanel/Primary
onready var secondary_item_collector_holder:Control = $ItemStatsPanel/Secondary

func update_data(item:Interactable):
	if item == null:
		clear_all()
		return
		
	if item.primary_item_collector != null:		
		add_or_update_ammo_collector_holder(primary_item_collector_holder, item.primary_item_collector)
	else:
		primary_item_collector_holder.hide()
		
	if item.secondary_item_collector != null:
		add_or_update_ammo_collector_holder(secondary_item_collector_holder, item.secondary_item_collector)
	else:
		secondary_item_collector_holder.hide()
		
	if item.primary_item_collector == null and item.secondary_item_collector == null:
		clear_all()
		
func clear_all():
	#self.hide()
	clear_item_collector_holder(primary_item_collector_holder)
	clear_item_collector_holder(secondary_item_collector_holder)
		

func clear_item_collector_holder(item_collector_holder:Control):
	if item_collector_holder != null:
		for item in item_collector_holder.get_children():
			if item is AmmoCollectorUI:
				item_collector_holder.remove_child(item)
		
	
func add_or_update_ammo_collector_holder(item_collector_holder:Control, ammo_collector:AmmoCollector):
	#self.show()
	item_collector_holder.show()
	
	var found_item_collector_ui:AmmoCollectorUI = null
	
	if item_collector_holder.has_node(ammo_collector.item_name):
		found_item_collector_ui = item_collector_holder.get_node(ammo_collector.item_name)

	if found_item_collector_ui:
		found_item_collector_ui.update_data(ammo_collector)		
	else:
		clear_item_collector_holder(item_collector_holder)
		var ammo_collector_ui = load("res://ui/stats_panels/item_stats_panel/ammo_collector_ui/AmmoCollectorUI.tscn").instance()
		ammo_collector_ui.name = ammo_collector.item_name
		
		item_collector_holder.add_child(ammo_collector_ui) 
		
		ammo_collector_ui.update_data(ammo_collector)
	
