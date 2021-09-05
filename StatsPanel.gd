extends MarginContainer

class_name StatsPanel

export var health = 100
export var energy = 100

onready var health_progress = $VBoxContainer/HBoxContainer/Health
onready var energy_progress = $VBoxContainer/HBoxContainer2/Energy

func _ready():
	health_progress.value = health
	energy_progress.value = energy

func get_health():
	return health_progress.value

func get_energy():
	return energy_progress.value

func set_health(new_value):
	health_progress.value = new_value

func set_energy(new_value):
	energy_progress.value = new_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
