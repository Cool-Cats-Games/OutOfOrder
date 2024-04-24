extends "res://Prefabs/SimpleEnemy.gd"

func get_animation_controller():
	return $MeshContainer/AnimationPlayer

func walk_to(point):
	set_state("WalkTo", {"points": [point]})

func follow_path(points):
	print(points)
	set_state("WalkTo", {"points": points})
