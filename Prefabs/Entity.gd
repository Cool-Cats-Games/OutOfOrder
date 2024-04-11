extends RigidBody3D

var hp = 100.0

func take_damage(dmg, dir):
	hp -= dmg
	$EntityHPBar.update_percent(hp)
	if hp <= 0.0:
		queue_free()
	apply_force(dir * mass * dmg * 50 )
