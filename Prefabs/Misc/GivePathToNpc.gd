extends Path3D


func give_path_to(npc):
	npc.follow_path(Array(curve.get_baked_points()))
