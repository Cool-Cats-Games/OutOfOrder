extends Node


static func get_world(tree):
	return tree.get_first_node_in_group("World")

static func play_sound_at(sfx, tree, pos = Vector3.ZERO, vol = 0.0, pitch = 1.0, freeAfterPlay = true):
	var dsfx = load("res://Prefabs/3dSoundPlayer.tscn").instantiate()
	get_world(tree).add_child(dsfx)
	dsfx.configure(sfx, pos, vol, pitch, freeAfterPlay)
	dsfx.play_random()
