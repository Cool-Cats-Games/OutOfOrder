extends Node


static func get_world(tree):
	return tree.get_first_node_in_group("World")

static func play_sound_at(sfx, tree, pos = Vector3.ZERO, vol = 0.0, pitch = 1.0, freeAfterPlay = true, attentuationModel = 0):
	var dsfx = load("res://Prefabs/3dSoundPlayer.tscn").instantiate()
	get_world(tree).add_child(dsfx)
	dsfx.configure(sfx, pos, vol, pitch, freeAfterPlay, attentuationModel)
	dsfx.play_random()

static func play_mono_sound(sfx, tree, volume = 0.0):
	if sfx is String:
		sfx = load(sfx)
	var dsfx = AudioStreamPlayer.new()
	dsfx.bus = "SFX"
	dsfx.volume_db = volume
	dsfx.stream = sfx
	get_world(tree).add_child(dsfx)
	dsfx.finished.connect(dsfx.queue_free)
	dsfx.play()

static func random_vector(rmin = -1.0, rmax = 1.0):
	return Vector3(randf_range(rmin, rmax),randf_range(rmin, rmax),randf_range(rmin, rmax))
	

static func ShortestRotation(to : Quaternion, from : Quaternion) -> Quaternion:
	if to.dot(from) < 0:
		return to * (from * -1).inverse()
	else:
		return to * from.inverse()
