extends Character
class_name YBot

func _process(delta):
	print($ybot/Armature/Skeleton.get_bone_rest(0))
