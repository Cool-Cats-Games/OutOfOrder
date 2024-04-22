extends RigidBody3D

var launchForce = 19.0

func launch(dir, fbasis, multiplier = 1.0):
	look_at(fbasis)
	apply_force(dir * launchForce * multiplier)



func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(global_position.direction_to(body.global_position))
	queue_free()
	pass # Replace with function body.
