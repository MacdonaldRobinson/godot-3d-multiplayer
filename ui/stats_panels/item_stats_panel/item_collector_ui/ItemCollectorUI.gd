extends VBoxContainer
class_name ItemCollectorUI

onready var _item_name:Label = $ItemName
onready var _current_amount:Label = $CurrentOfMax/Current
onready var _max_amount:Label = $CurrentOfMax/Max

func update_data(item_collector:ItemCollector):
	if _item_name == null:
		self.hide()
		return 
		
	if item_collector == null:
		self.hide()
		return
		
	_item_name.text = item_collector.item_name	
	_current_amount.text = String(item_collector.current_amount)
	_max_amount.text = String(item_collector.max_capacity)
