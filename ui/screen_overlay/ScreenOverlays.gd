extends Control
class_name ScreenOverlay

onready var player_stats_panel:PlayerStatsPanel = $Top/PlayersStatsPanel
onready var collected_items_panel:SlotsPanel = $HBoxContainer/Bottom/CollectedItemsStatsPanel
onready var currently_equipped_item_stats_panel:ItemStatsPanel = $HBoxContainer/Bottom/CurrentlyEquippedItemStatsPanel
onready var skill_bar:SkillBarUI = $HBoxContainer/Bottom/SkillBar
onready var chat_panel:ChatPanel = $HBoxContainer/VBoxContainer/ChatPanel
onready var inventory:InventoryUI = $InventoryUI

func update_data(player_name:String, 
			health:int, 
			energy:int,
			currently_equipped_item:Interactable, 
			collected_items:ItemCollectors):
	player_stats_panel.update_data(player_name, health, energy)
	currently_equipped_item_stats_panel.update_data(currently_equipped_item)
	collected_items_panel.update_data(collected_items)
	
	var inventory_ui_config:InventoryUIConfig = InventoryUIConfig.new()
	inventory_ui_config.item_collectors = collected_items	
	
	inventory.update_data(inventory_ui_config)
	
	var skill_bar_config:SkillBarUIConfig = SkillBarUIConfig.new()
	skill_bar_config.item_collectors = collected_items
	
	skill_bar.update_data(skill_bar_config)
	
func _input(event):
	if Globals.is_mouse_captured():
		chat_panel.modulate.a = 0.5
		chat_panel.send_message.release_focus()
	else:
		chat_panel.modulate.a = 1
