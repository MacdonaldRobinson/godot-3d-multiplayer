extends GridContainer
class_name ItemSlotsUI

var _config:ItemSlotsUIConfig = ItemSlotsUIConfig.new()
var _grid_container:GridContainer = self
var _item_slot_ui_scene:PackedScene = preload("res://ui/item_slot/ItemSlotUI.tscn")

signal item_clicked(item_collector)

func update_data(config:ItemSlotsUIConfig):
	_config = config
	_populate()
	
func _clear_items():
	for child in _grid_container.get_children():
		_grid_container.remove_child(child)

func _create_empty_slots():
	if _grid_container.get_child_count() != _config.max_capacity:		
		_clear_items()
		
		for index in _config.max_capacity:
			var found_slot:ItemSlotUI = null
			var config:ItemSlotUIConfig = ItemSlotUIConfig.new()

			if _grid_container.get_child_count() > index:
				found_slot = _grid_container.get_child(index)
			
			if !found_slot:
				var item_slot_ui:ItemSlotUI = _item_slot_ui_scene.instance()
				item_slot_ui.name = String(index)				
				
				item_slot_ui.update_data(config)
				_grid_container.add_child(item_slot_ui , true)


func _update_slots_from_items():
	for item in _config.item_collectors.get_all():
		if item is ItemCollector:
			var found_item_slot:ItemSlotUI = null
			var config:ItemSlotUIConfig = ItemSlotUIConfig.new()
			config.item_collector = item
			
			if _grid_container.has_node(item.item_name):
				found_item_slot = _grid_container.get_node(item.item_name)
				
				if found_item_slot:
					found_item_slot.update_data(config)
			else:
				var empty_slot = _get_avaiable_slot()
				empty_slot.name = item.item_name
				empty_slot.update_data(config)
					

func _empty_slots_if_no_item_collector():
	var slot_index = 0
	for slot in _grid_container.get_children():
		if slot is ItemSlotUI:
			var found = _config.item_collectors.get_all().find(slot._config.item_collector)
			
			if found == -1:
				slot.name = String(slot_index)
				slot.update_data(ItemSlotUIConfig.new())
				
		slot_index +=1
		
func _get_avaiable_slot() -> ItemSlotUI:
	for slot in _grid_container.get_children():
		if slot is ItemSlotUI:
			if slot._config.item_collector == null:
				return slot

	return null
	
func _populate():	
	_create_empty_slots()
	_update_slots_from_items()	
	_empty_slots_if_no_item_collector()
	
	for slot in _grid_container.get_children():
		if slot is ItemSlotUI:
			var config:ItemSlotUIConfig = slot._config
			config.show_item_count = _config.show_item_count
			
			if !slot.is_connected("item_clicked", self,  "_item_clicked"):
				slot.connect("item_clicked", self, "_item_clicked")
				
			slot.update_data(config)

func _item_clicked(item_collector:ItemCollector):
	emit_signal("item_clicked", item_collector)
