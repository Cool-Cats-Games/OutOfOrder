extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	get_tree().call_group("ModeQueue", "hide")
	AudioManager.fade_out_music()
	pass # Replace with function body.




func _on_animation_player_animation_finished(anim_name):
	var t = get_tree().get_first_node_in_group("Transitions")
	t.fade_out()
	t.on_fadeout_complete.connect(ModeManager.load_results_screen)
	pass # Replace with function body.
