extends Node

signal on_music_started
signal on_music_stopped

var currentPlaylist
var currentPart
var isCrossfading = false
var isPlayingPlaylist = false
var crossfadeRate = 0.1

func _ready():
	for playlist in get_children():
		if playlist.get_child_count() > 0: #meanign this is a playlist
			for part in playlist.get_children():
				get_fader(part).on_fadeout_finished.connect(on_finished_fadeout)

func crossfade_parts(pin, pout):
	fade_out_part(pin)
	fade_in_part(pout)

func fade_in_part(part):
	get_fader(part).fade_in()

func fade_out_current_part():
	get_fader(currentPart).fade_out()

func fade_out_part(part):
	get_fader(part).fade_out()

func get_current_part():
	if not isPlayingPlaylist:
		return ""
	return currentPart.name

func get_current_playlist():
	if not isPlayingPlaylist:
		return ""
	return currentPlaylist.name

func get_fader(part):
	return part.get_node("Fader")

func on_finished_fadeout(part, playlist):
	if playlist != currentPlaylist:
		stop_playlist_playback(playlist)

func play_playlist(playlistName = "Playlist", startingPart = "A", fade = false, forceRestart = false):
	#nothing is playing
	if not isPlayingPlaylist:
		start_playlist(playlistName, startingPart, fade)
	#were already playing a different playlist
	elif currentPlaylist.name != playlistName:
		stop(fade)
		start_playlist(playlistName,startingPart, fade)
	#we're already playing the same playlist but different part
	elif startingPart != currentPart.name:
		switch_part(startingPart, fade)
	#we're already playing the same playlist and part
	else:
		if forceRestart: #force the playlist to restart anyway
			start_playlist(playlistName, startingPart, fade)
		else: #do nothing
			return

func play_sound_at(stream, volume = 0.0, bus = "SFX", varied = false):
	if stream is Array:
		stream = stream.pick_random()
	if stream is String:
		stream = load(stream)
	$SoundChannel.stream = stream
	$SoundChannel.volume_db = volume
	$SoundChannel.bus = bus
	if varied:
		$SoundChannel.pitch_scale = randf_range(0.85,1.15)
	$SoundChannel.play()

func scale_to_db(ratio = 1.0):
	return lerp(-80.0,0.0, ratio)

func set_part_volume(part, scale = 1.0):
	get_fader(part).target_db = scale_to_db(scale)
	part.volume_db = scale_to_db(scale)

func start_playlist(playlistName = "Playlist", startingPart = "A", fadeIn = false):
	var playlist = get_node(playlistName)
	if not is_instance_valid(playlist): return
	isPlayingPlaylist = true
	currentPlaylist = playlist
	for part in playlist.get_children():
		part.play() #all the parts should be playing simultaneously, they're designed to be the same tempo
		if part.name == startingPart:
			#this is the part we want to start playing, so either fade it in or have it start playing
			if fadeIn:
				part.volume_db = scale_to_db(0.0)
				fade_in_part(part)
			else:
				set_part_volume(part,1.0)
			currentPart = part
		else:
			set_part_volume(part, 0.0)
	on_music_started.emit()

func stop(fadeout = true):
	if not isPlayingPlaylist: return
	if fadeout:
		fade_out_current_part()
	else:
		stop_playlist_playback(currentPlaylist)
	isPlayingPlaylist = false
	currentPart = null
	currentPlaylist = null
	on_music_stopped.emit()

func stop_part(part):
	set_part_volume(part, 0.0)
	part.stop()

func stop_playlist_playback(playlist):
	for part in playlist.get_children():
		part.stop()

func switch_part(to = "A", crossfade = true):
	#should only ever call this when its intended to be switching parts in the same playlist
	var target = currentPlaylist.get_node(to)
	if not is_instance_valid(target): return #part not found in current palylist, so leave and keep the current part going
	if crossfade:
		fade_out_part(currentPart)
	else:
		set_part_volume(currentPart, 0.0)
	currentPart = target #switch current part
	if crossfade:
		fade_in_part(currentPart) #fade in new part
	else:
		set_part_volume(currentPart, 1.0)

