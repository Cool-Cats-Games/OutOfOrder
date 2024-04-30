extends Node2D

func _ready():
	$VBoxContainer/btn_PlayAgain.grab_focus()

func _on_btn_play_again_pressed():
	#get_tree().call_group("HUD", "show")
	get_tree().change_scene_to_file(GameDataManager.gameData.currentRoom)
	pass # Replace with function body.


func _on_btn_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.
