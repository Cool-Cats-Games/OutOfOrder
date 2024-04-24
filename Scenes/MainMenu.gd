extends Node2D




func _on_btn_ng_pressed():
	get_tree().call_group("HUD", "show")
	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
	pass # Replace with function body.


func _on_btn_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
