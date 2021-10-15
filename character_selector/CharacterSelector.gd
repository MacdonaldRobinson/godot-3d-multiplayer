extends Spatial

onready var selected_character_holder:Spatial = $SelectedCharacterHolder
onready var characters:Characters = load("res://player/characters/Characters.tscn").instance()
onready var selected_character:Character

func _ready():
	load_character_at_index(0)

func load_character(character:Character):
	if character == null:
		return
		
	for child in selected_character_holder.get_children():
		selected_character_holder.remove_child(child)		
	
	var selected_character = character.duplicate()
		
	selected_character_holder.add_child(selected_character)
	
func load_character_at_index(index:int):
	if index > -1 and characters.get_child_count() > index:
		var character = characters.get_child(index)
		load_character(character)

func get_current_index() -> int:
	if selected_character_holder.get_child_count() > 0:
		var found_node = characters.find_node(selected_character_holder.get_child(0).name)
		if found_node:
			return found_node.get_index()
			
	return -1

func _on_Previous_pressed():	
	var index = get_current_index()
	
	if index == -1:
		load_character(characters.get_child(0))
	else:
		load_character_at_index(index-1)
	
func _on_Next_pressed():
	var index = get_current_index()
	
	if index == -1:
		load_character_at_index(0)
	else:
		load_character_at_index(index+1)


func _on_Select_pressed():
	if get_current_index() > -1:
		var file_name = characters.get_child(get_current_index()).filename
		
		Globals.peer_data.selected_character_scene = file_name
		get_tree().change_scene("res://lobby/Lobby.tscn")
