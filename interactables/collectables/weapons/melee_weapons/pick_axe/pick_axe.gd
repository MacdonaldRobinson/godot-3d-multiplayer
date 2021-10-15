extends MeleeWeapon
class_name PickAxe

onready var animation_player:AnimationPlayer = $AnimationPlayer

func _ready():
	item_name = "Pick Axe"
	pass # Replace with function body.

func primary_action():
	var owner:Player = get_parent().owner	
	var exclude:Array = []
	
	exclude.append(owner)
	
	self.enable_collisions(exclude)
	
	animation_player.play("swing")


func _on_Axe_body_entered(body):
	if body is Interactable:
		body.take_damage(1)
