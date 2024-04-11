extends RigidBody3D

var hp = 100.0

func take_damage(actor):
	var dmg = (actor.linear_velocity - linear_velocity).length()
	hp -= dmg
	$EntityHPBar.update_percent(hp)
	if hp <= 0.0:
		queue_free()
	apply_force(actor.global_transform.basis.z * mass * dmg * 50 )
