extends Control
class_name ScreenOverlay

onready var player_stats_panel:PlayerStatsPanel = $Top/PlayersStatsPanel
onready var collected_items_panel:SlotsPanel = $Bottom/CollectedItemsStatsPanel
onready var currently_equipped_item_stats_panel:ItemStatsPanel = $Bottom/CurrentlyEquippedItemStatsPanel

func update_data(player_name:String, 
			health:int, 
			energy:int,
			currently_equipped_item:Interactable, 
			collected_items:Array):				
	
	player_stats_panel.update_data(player_name, health, energy)
	currently_equipped_item_stats_panel.update_data(currently_equipped_item)
	collected_items_panel.update_data(collected_items)	

#	Globals.peer_data.health = health
#	Globals.peer_data.energy = energy	
	
