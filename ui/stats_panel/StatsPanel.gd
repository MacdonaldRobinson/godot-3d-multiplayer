extends MarginContainer

class_name StatsPanel

export var health = 100 setget _set_health
export var energy = 100 setget _set_energy

onready var _health_progress = $VBoxContainer/HBoxContainer/Health
onready var _energy_progress = $VBoxContainer/HBoxContainer2/Energy

func _set_health(new_value):
	health = new_value
	_health_progress.value = health
	
func _set_energy(new_value):
	energy = new_value	
	_energy_progress.value = energy
