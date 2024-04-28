extends RigidBody3D

var canFree = true
var launchForce = 19.0

var splatFX = ["res://Sounds/sfx_splat_01.wav", "res://Sounds/sfx_splat_02.wav"]

func launch(dir, fbasis, multiplier = 1.0, forceAlive = 0.0):
	look_at(fbasis)
	apply_force(dir * launchForce * multiplier)
	if forceAlive > 0.0:
		canFree = false
		$Timer.start(forceAlive)


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.take_damage(global_position.direction_to(body.global_position))
	if canFree:
		Utils.play_sound_at(splatFX.pick_random(), get_tree(), global_position, -2.0)
		queue_free()
	pass # Replace with function body.

func _on_timer_timeout():
	canFree = true
	pass # Replace with function body.
