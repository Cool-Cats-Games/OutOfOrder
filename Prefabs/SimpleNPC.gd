extends "res://Prefabs/SimpleEnemy.gd"

func get_animation_controller():
	return $MeshContainer/AnimationPlayer

func walk_to(point):
	set_state("WalkTo", {"points": [point]})

func follow_path(points):
	print(points)
	set_state("WalkTo", {"points": points})


func _on_flee_panic_timer_timeout():
	get_tree().call_group("PatrolPath", "give_path_to", self)
	if randf() < 0.5:
		$StateMachine/WalkTo.points.reverse()
	$MeshContainer/AnimationPlayer.play("Flee")
	pass # Replace with function body.
