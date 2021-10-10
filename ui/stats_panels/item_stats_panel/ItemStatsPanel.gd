extends Node
class_name ItemStatsPanel

func update_data(item:Interactable):
	if item == null:
		return
	
	for child in self.get_children():
		self.remove_child(child)
		
	if item is Weapon:
		add_ammo_collector_ui(item.primary_item_collector)
		add_ammo_collector_ui(item.secondary_item_collector)

func add_ammo_collector_ui(ammo_collector:AmmoCollector):
	var ammo_collector_ui = load("res://ui/stats_panels/item_stats_panel/ammo_collector_ui/AmmoCollectorUI.tscn").instance()
	self.add_child(ammo_collector_ui)
	
	ammo_collector_ui.update_data(ammo_collector)
