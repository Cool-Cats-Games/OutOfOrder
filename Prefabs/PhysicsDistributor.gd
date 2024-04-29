extends Area3D

var bouncyMat = preload("res://Materials/physMat_bouncy.tres")

var firstFrame = true

func distribute(force = Vector3.ZERO, torque = Vector3.ZERO, isImpulse = false):
	for b in get_overlapping_bodies():
		if not b is RigidBody3D:continue
		if b.get_collision_layer_value(2) or b.get_collision_layer_value(6):
			continue
		if b == get_parent():
			continue
		if b.get_parent() != Utils.get_world(get_tree()):
			b.reparent(Utils.get_world(get_tree()))
		b.physics_material_override = bouncyMat
		b.freeze = false
		if isImpulse:
			b.apply_impulse(force)
			b.apply_torque_impulse(torque)
		else:
			b.apply_force(force)
			b.apply_torque(torque)

func apply_random(strength = 1.0):
	distribute(Utils.random_vector() * strength, Utils.random_vector() * strength, true)
