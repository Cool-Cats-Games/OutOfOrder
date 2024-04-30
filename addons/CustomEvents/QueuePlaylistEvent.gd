extends "res://addons/CustomEvents/GenericEvent.gd"

@export var fadeInPlaylist = false
@export var playlistName = ""
@export var part = "A"
@export var forceRestart = false
@export var onlyPlayIfNoMusic = false

func trigger(by = null):
	super.trigger(by)
	play_playlist.call_deferred()

func play_playlist(_part = part):
	if AudioManager.isPlayingPlaylist and onlyPlayIfNoMusic:
		return
	if playlistName != "":
		AudioManager.play_playlist(playlistName, _part, fadeInPlaylist, forceRestart)
