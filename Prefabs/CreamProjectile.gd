extends RigidBody3D

var launchForce = 66.0
var splatterRef
var source
var cnormal = Vector3()

func launch(dir, fbasis, _splatterRef, _source, multiplier = 1.0):
	look_at(fbasis)
	splatterRef = _splatterRef
	source = _source
	apply_force(dir * launchForce * multiplier)

func _integrate_forces(state):
	rotation_degrees.x = lerp(0.0, -90.0, -linear_velocity.y / 10.0)
	if state.get_contact_count() > 0:
		cnormal = state.get_contact_local_normal(0)

func _on_area_3d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(2,global_position.direction_to(body.global_position), self)
	if not body.get_collision_layer_value(8):
		#spawn splash effect
		splatterRef.global_position = global_position
		splatterRef.global_transform = splatterRef.global_transform.looking_at(cnormal)
		splatterRef.global_position += cnormal * 25
		splatterRef.toggle(true)
		queue_free()
	pass # Replace with function body.

