extends Control
class_name SkillBarUI

var _config:SkillBarUIConfig = SkillBarUIConfig.new()

onready var _grid_container:GridContainer = $CenterContainer/ItemSlotsUI
onready var item_slots_ui:ItemSlotsUI = $CenterContainer/ItemSlotsUI

signal item_clicked(item_collector)

func update_data(config:SkillBarUIConfig):
	_config = config
	
	var item_slots_ui_config:ItemSlotsUIConfig = ItemSlotsUIConfig.new()

	var skill_item_collectors:ItemCollectors = ItemCollectors.new()
	skill_item_collectors.get_all().append_array(config.item_collectors.get_skills())	
	
	item_slots_ui_config.item_collectors = skill_item_collectors
	item_slots_ui_config.max_capacity = 5
	item_slots_ui_config.show_item_count = false
	
	item_slots_ui.update_data(item_slots_ui_config)
		
func _on_ItemSlotsUI_item_clicked(item_collector):
	emit_signal("item_clicked", item_collector)
