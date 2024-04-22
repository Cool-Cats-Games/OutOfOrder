extends "res://Prefabs/SimpleEnemy.gd"

var projectileRef = load("res://Prefabs/GreaseProjectile.tscn")

func launch(isR = true):
	var gp = projectileRef.instantiate()
	Utils.get_world(get_tree()).add_child(gp)
	gp.position = $TrapRPoint.global_position if isR else $TrapLPoint.global_position
	var launchDir = global_position.direction_to(get_tree().get_first_node_in_group("Player").global_position)
	gp.launch(launchDir + Vector3.UP * 2, $greasePoint.global_position)
	
