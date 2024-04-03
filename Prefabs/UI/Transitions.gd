extends CanvasLayer

signal on_fadeout_complete()
signal on_fadein_complete()

func fade_out():
	$Center/AnimationPlayer.play("FadeOut")
	AudioManager.play_sound_at("res://Sounds/Transitions/sfx_transition_2.wav",
	$Center.position,4.0, "SoundFX", false, 0.0 )

func fade_in():
	$Center/AnimationPlayer.play("FadeIn")
	var sfx = ["res://Sounds/Transitions/sfx_transition_1.wav",
	"res://Sounds/Transitions/sfx_transition_3.wav",
	"res://Sounds/Transitions/sfx_transition_4.wav"]
	AudioManager.play_sound_at(sfx.pick_random(), $Center.position,0.0, "SoundFX", false, 0.0 )

func set_in():
	$Center/AnimationPlayer.play("set_in")

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"FadeOut":
			on_fadeout_complete.emit()
		"FadeIn":
			on_fadein_complete.emit()
	pass # Replace with function body.
