extends Control
class_name ItemStatsPanelUI

onready var primary_item_collector_holder:Control = $MarginContainer/ItemStatsPanel/Primary
onready var secondary_item_collector_holder:Control = $MarginContainer/ItemStatsPanel/Secondary

func update_data(item:Interactable):
	if item == null:
		clear_all()
		return
		
	if item.primary_item_collector != null:		
		add_or_update_item_collector_holder(primary_item_collector_holder, item.primary_item_collector)
	else:
		primary_item_collector_holder.hide()
		
	if item.secondary_item_collector != null:
		add_or_update_item_collector_holder(secondary_item_collector_holder, item.secondary_item_collector)
	else:
		secondary_item_collector_holder.hide()
		
	if item.primary_item_collector == null and item.secondary_item_collector == null:
		clear_all()
		
func clear_all():
	clear_item_collector_holder(primary_item_collector_holder)
	clear_item_collector_holder(secondary_item_collector_holder)
		

func clear_item_collector_holder(item_collector_holder:Control):
	if item_collector_holder != null:
		for item in item_collector_holder.get_children():
			if item is ItemCollectorUI:
				item_collector_holder.remove_child(item)
	
		item_collector_holder.hide()
	
func add_or_update_item_collector_holder(item_collector_holder:Control, item_collector:ItemCollector):
	item_collector_holder.show()
	
	var found_item_collector_ui:ItemCollectorUI = null
	
	if item_collector_holder.has_node(item_collector.item_name):
		found_item_collector_ui = item_collector_holder.get_node(item_collector.item_name)

	if found_item_collector_ui:
		found_item_collector_ui.update_data(item_collector)		
	else:
		clear_item_collector_holder(item_collector_holder)
		var item_collector_ui:ItemCollectorUI = load("res://ui/stats_panels/item_stats_panel/item_collector_ui/ItemCollectorUI.tscn").instance()
		item_collector_ui.name = item_collector.item_name
		
		item_collector_holder.add_child(item_collector_ui) 
		
		item_collector_ui.update_data(item_collector)
