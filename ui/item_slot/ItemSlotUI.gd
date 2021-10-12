extends NinePatchRect
class_name ItemSlotUI

var _config:ItemSlotUIConfig = ItemSlotUIConfig.new()

signal item_clicked(item_collector)

func update_data(config:ItemSlotUIConfig):
	var item_background:NinePatchRect = $ItemBackground
	var item:TextureButton = $ItemBackground/Item
	var item_count:Label = $ItemBackground/Count

	if !item:
		return
		
	_config = config
	
	if _config.slot_bg_texture:
		item_background.texture = _config.slot_bg_texture
	
	if _config.item_collector:
		item_count.text = String(_config.item_collector.current_amount)
		
		if _config.item_collector.item_icon_texture:
			item.texture_normal = _config.item_collector.item_icon_texture	
	else:
		item_count.text = "0"
		item.texture_normal = null
		
	if _config.show_item_count:
		item_count.show()
	else:
		item_count.hide()


func _on_Item_pressed():
	emit_signal("item_clicked", _config.item_collector)
