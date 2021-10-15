extends Ammo
class_name Bullet
func get_class(): return "Bullet"


func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
		
	if weapon_ray_cast:
		var collider = weapon_ray_cast.get_collider()
		if collider:
			var bullet_hole:BulletHole = load("res://interactables/collectables/weapons/ammos/bullet/bullet_hole/BulletHole.tscn").instance()
			var collision_point = weapon_ray_cast.get_collision_point()
			var collider_normal = weapon_ray_cast.get_collision_normal()

			collider.add_child(bullet_hole)

			bullet_hole.global_transform.origin = collision_point
			
			if collider_normal != Vector3.UP:
				bullet_hole.look_at(collision_point + collider_normal, Vector3.UP)	
			else:
				bullet_hole.rotate_x(deg2rad(90))
				
			
	queue_free()
