extends Path3D

@export var randomReverse = false

func give_path_to(npc):
	var ar = Array(curve.get_baked_points())
	if randf() < 0.5:
		ar.reverse()
	npc.follow_path(ar)
