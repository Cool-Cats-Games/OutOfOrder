extends Area3D

var firstFrame = true

func distribute(force = Vector3.ZERO, torque = Vector3.ZERO, isImpulse = false):
	for b in get_overlapping_bodies():
		if not b is RigidBody3D:continue
		if b == get_parent():
			continue
		b.freeze = false
		if isImpulse:
			b.apply_impulse(force)
			b.apply_torque_impulse(torque)
		else:
			b.apply_force(force)
			b.apply_torque(torque)

func apply_random(strength = 1.0):
	distribute(Utils.random_vector() * strength, Utils.random_vector() * strength, true)
