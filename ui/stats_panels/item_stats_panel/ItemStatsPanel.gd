extends Node
class_name ItemStatsPanel

onready var _item_name:Label = $ItemName
onready var _current_amount:Label = $CurrentOfMax/Current
onready var _max_amount:Label = $CurrentOfMax/Max

func update_data(item:Interactable):
	if item == null:
		return
		
	_item_name.text = item.item_name
	
	if item is Weapon:
		_current_amount.text = String(item.current_ammo_amount)
		_max_amount.text = String(item.max_capacity)
