extends Node

var currentPlaylist
var currentPart
var targetPart
var isCrossfading = false
var crossfadeRate = 0.1

func _process(delta):
	if isCrossfading:
		currentPart.volume_db = lerp(currentPart.volume_db, -80.0, crossfadeRate)
		targetPart.volume_db = lerp(targetPart.volume_db, 0.0, crossfadeRate)
		if targetPart.volume_db > -0.01:
			currentPart = targetPart
			isCrossfading = false

func scale_to_db(ratio = 1.0):
	return lerp(-80.0,0.0, ratio)

func play_playist(playlistName = "Playlist", startingPart = "A"):
	var p = get_node(playlistName)
	if is_instance_valid(p):
		currentPlaylist = p
		for s in p.get_children():
			if s.name != startingPart:
				s.volume_db = scale_to_db(0.0)
			else:
				currentPart = s
			s.play()

func switch_part(to = "A"):
	targetPart = currentPlaylist.get_node(to)
	targetPart.stop()
	targetPart.play()
	isCrossfading = true
