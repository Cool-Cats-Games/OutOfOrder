extends RigidBody3D

@export var hp = 25.0
var maxHP

func _ready():
	maxHP = hp

func take_damage(dmg, dir):
	hp -= dmg
	$EntityHPBar.update_percent(hp, maxHP)
	if hp <= 0.0:
		queue_free()
	apply_force(dir * mass * dmg * 50 )


