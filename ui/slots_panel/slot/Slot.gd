extends Node
class_name Slot
func get_class(): return "Slot"


func update_data(item_collector:ItemCollector):	
	var item_name_label: Label = get_node("ItemName");
	item_name_label.text = item_collector.item_name + "("+String(item_collector.current_amount)+")"
