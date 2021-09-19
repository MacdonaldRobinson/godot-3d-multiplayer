extends Node
class_name PlayerStatsPanel

onready var _player_name:Label = $VBoxContainer/PlayerName
onready var _health_progress_bar:ProgressBar = $Stats/HBoxContainer/Health
onready var _energy_progress_bar:ProgressBar = $Stats/HBoxContainer2/Energy

func update_data(player_name:String, health:int, energy:int):
	_player_name.text = player_name
	_health_progress_bar.value = health
	_energy_progress_bar.value = energy

