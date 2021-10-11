extends TextureButton

func get_drag_data(position):
	var data = {}
	var owner = get_parent().owner
		
	if owner is ItemSlotUI:
		data.owner = owner
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = self.texture_normal
	drag_texture.rect_size = Vector2(100, 100)
	
	var control:Control = Control.new()
	control.add_child(drag_texture)
	
	drag_texture.rect_position = -0.5 * drag_texture.rect_size

	set_drag_preview(control)
	
	return data
	
func drop_data(position, data):
	if data and data.owner and data.owner is ItemSlotUI:
		var owner = data.owner as ItemSlotUI
		var item_collector:ItemCollector = owner._config.item_collector
		
		if !item_collector:
			return
			
		var grid_container:GridContainer = data.owner.get_parent()
		
		if !grid_container:
			return
		
		var dragged_item_slot:ItemSlotUI = grid_container.get_node(item_collector.item_name)
		
		if !dragged_item_slot:
			return
			
		if self.get_parent().owner is ItemSlotUI:
			var self_owner = self.get_parent().owner as ItemSlotUI
			var dropped_item_slot:ItemSlotUI = grid_container.get_child(self_owner.get_index())
			
			if dropped_item_slot:
				grid_container.move_child(dragged_item_slot, dropped_item_slot.get_index())
				#grid_container.move_child(dropped_item_slot, dragged_item_slot.get_index())
		
		pass
	
func can_drop_data(position, data):
	return true
