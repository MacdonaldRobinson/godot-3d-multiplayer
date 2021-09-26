extends VBoxContainer

onready var _item_name:Label = $ItemName
onready var _current_amount:Label = $CurrentOfMax/Current
onready var _max_amount:Label = $CurrentOfMax/Max

func update_data(ammo_collector:AmmoCollector):
	if _item_name == null:
		return 
		
	if ammo_collector == null:
		return
		
	_item_name.text = ammo_collector.ammo_name	
	_current_amount.text = String(ammo_collector.current_amount)
	_max_amount.text = String(ammo_collector.max_capacity)
