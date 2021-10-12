extends UI
class_name InventoryUI

onready var item_slots_ui:ItemSlotsUI = $PopupWindowUI/VBoxContainer/Middle/MarginContainer/ItemSlotsUI
onready var popup_window_ui:PopupWindowUI = $PopupWindowUI
var _config:InventoryUIConfig

signal item_clicked(item_collector)

func _ready():
	show()

func update_data(config:InventoryUIConfig):	
	_config = config
	
	var item_slots_ui_config:ItemSlotsUIConfig = ItemSlotsUIConfig.new()

	var inventory_item_collectors:ItemCollectors = ItemCollectors.new()
	inventory_item_collectors.get_all().append_array(config.item_collectors.get_non_skills())	
		
	item_slots_ui_config.item_collectors = inventory_item_collectors
	item_slots_ui_config.show_item_count = true
	
	if !item_slots_ui.is_connected("item_clicked", self,  "_item_clicked"):
		item_slots_ui.connect("item_clicked", self, "_item_clicked")
		
	item_slots_ui.update_data(item_slots_ui_config)	

func _item_clicked(item_collector:ItemCollector):
	emit_signal("item_clicked", item_collector)


func _on_PopupWindowUI_close_window():
	self.hide()
