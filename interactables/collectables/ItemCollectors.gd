extends Resource
class_name ItemCollectors

var _item_collectors:Array = [] 

func get_skills() -> Array:
	var skill_item_collectors:Array = []
	
	for item_collector in _item_collectors:
		if item_collector is ItemCollector:
			if item_collector.is_skill:
				skill_item_collectors.append(item_collector)
				
	return skill_item_collectors
	
func get_non_skills() -> Array:
	var non_skill_item_collectors:Array = []
	
	for item_collector in _item_collectors:
		if item_collector is ItemCollector:
			if !item_collector.is_skill:
				non_skill_item_collectors.append(item_collector)
				
	return non_skill_item_collectors
	
func get_all()->Array:
	return _item_collectors

func get_by_index(index:int):
	return _item_collectors[index]
