extends Node

signal on_fadeout_finished(part, playlist)
signal on_fadein_finished(part, playlist)

@onready var sound = get_parent()

var isFadeOut = false
var isFadeIn = false
var target_db = 0.0
var rate = 0.85
var reached = false

func _process(delta):
	sound.volume_db = lerp(sound.volume_db, target_db, rate)
	if abs(sound.volume_db - target_db) < 0.01 and not reached:
		if isFadeIn: on_fadein_finished.emit(sound, sound.get_parent())
		if isFadeOut: on_fadeout_finished.emit(sound, sound.get_parent())
		isFadeOut = false
		isFadeIn = false
		reached = true

func fade_in():
	target_db = 0.0
	reached = false
	isFadeIn = true

func fade_out():
	target_db = -80.0
	reached = false
	isFadeOut = true
