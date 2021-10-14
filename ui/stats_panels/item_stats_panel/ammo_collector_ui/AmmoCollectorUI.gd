extends VBoxContainer
class_name AmmoCollectorUI

onready var _item_name:Label = $ItemName
onready var _current_amount:Label = $CurrentOfMax/Current
onready var _max_amount:Label = $CurrentOfMax/Max

func update_data(ammo_collector:AmmoCollector):
	if _item_name == null:
		self.hide()
		return 
		
	if ammo_collector == null:
		self.hide()
		return
		
	_item_name.text = ammo_collector.item_name	
	_current_amount.text = String(ammo_collector.current_amount)
	_max_amount.text = String(ammo_collector.max_capacity)
