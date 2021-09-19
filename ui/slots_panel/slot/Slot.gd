extends Node
class_name Slot

func update_data(item_name:String):	
	var item_name_label: Label = get_node("ItemName");
	item_name_label.text = item_name
