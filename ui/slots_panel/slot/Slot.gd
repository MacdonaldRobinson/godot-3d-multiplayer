extends Node
class_name Slot
func get_class(): return "Slot"

onready var texture_button:TextureButton = $TextureButton
onready var item_name:Label = $ItemName

var current_item_collector:ItemCollector
var slot_index:int

func set_slot_index(index:int):
	slot_index = index

func update_data(item_collector:ItemCollector):	
	self.current_item_collector = item_collector
	var item_name_label: Label = get_node("ItemName");
	item_name_label.text = item_collector.item_name + "("+String(item_collector.current_amount)+")"

func get_current_item_collector() -> ItemCollector:
	return current_item_collector

func _on_TextureButton_pressed():
	if current_item_collector:
		if current_item_collector.call_back_method:
			current_item_collector.call_back_method.call_func(slot_index)
