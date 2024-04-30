extends Node2D

func _ready():
	$Transitions.fade_in()
	$Version.text = "VERSION " + str(Settings.version)


func _on_btn_ng_pressed():
	GameDataManager.gameData = load("res://Data/GameDataResource.tres")
	$VBoxContainer.hide()
	$Transitions.fade_out()
	$sfx_ng.play()
	AudioManager.stop()
	await $Transitions.on_fadeout_complete
	get_tree().change_scene_to_file("res://Scenes/BroomCloset.tscn")
	pass # Replace with function body.


func _on_btn_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.


func _on_btn_settings_pressed():
	open_settings()
	pass # Replace with function body.

func open_settings():
	var s = load("res://System/SettingsMenu.tscn").instantiate()
	add_child(s)
	s.connect("on_queue_exit", close_settings)
	process_mode = Node.PROCESS_MODE_DISABLED
	$VBoxContainer.visible = false

func close_settings():
	process_mode = Node.PROCESS_MODE_INHERIT
	$VBoxContainer.visible = true
	$VBoxContainer/btn_Settings.grab_focus()
	pass


func _on_btn_credits_pressed():
	$VBoxContainer.hide()
	$Transitions.fade_out()
	$sfx_credits.play()
	await $Transitions.on_fadeout_complete
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
	pass # Replace with function body.
