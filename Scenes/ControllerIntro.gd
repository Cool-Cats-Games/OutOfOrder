extends CanvasLayer




func _on_input_action_trigger_on_event_triggered():
	AudioManager.play_sound_at("res://Sounds/sfx_scifi_02.wav")
	$BoxContainer/VBoxContainer/Label3.text = " "
	$UI_Input_Switch.queue_free()
	$AnimationPlayer.play_backwards("fadein")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/Intro.tscn")
	pass # Replace with function body.
