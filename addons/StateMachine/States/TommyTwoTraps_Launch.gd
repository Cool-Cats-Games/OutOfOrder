extends State




func _on_animation_player_animation_finished(anim_name):
	state_machine.transition_to("Idle")
	pass # Replace with function body.
