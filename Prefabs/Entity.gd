extends RigidBody3D

@export var hp = 25.0

func take_damage(dmg, dir):
	hp -= dmg
	$EntityHPBar.update_percent(hp)
	if hp <= 0.0:
		queue_free()
	apply_force(dir * mass * dmg * 50 )


