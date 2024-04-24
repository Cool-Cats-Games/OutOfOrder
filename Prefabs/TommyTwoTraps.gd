extends "res://Prefabs/SimpleEnemy.gd"

var projectileRef = load("res://Prefabs/GreaseProjectile.tscn")
var launchDir = Vector3()

func launch(isR = true):
	var gp = projectileRef.instantiate()
	Utils.get_world(get_tree()).add_child(gp)
	gp.position = $TrapRPoint.global_position if isR else $TrapLPoint.global_position
	var target = get_tree().get_first_node_in_group("Player")
	if is_instance_valid(target):
		launchDir = global_position.direction_to(target.global_position)
	gp.launch(launchDir + Vector3.UP * 2, $greasePoint.global_position)
	
func get_animation_controller():
	return $TommyTwoTraps/AnimationPlayer
