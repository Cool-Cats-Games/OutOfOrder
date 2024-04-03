extends CanvasLayer

var firstFrame = true
var canAct = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$sfx_open.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if firstFrame:
		firstFrame = false
		canAct = true
		$VBoxContainer/btn_Settings.grab_focus()
	else:
		if canAct and (Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("ui_cancel")):
			canAct = false
			get_tree().paused = false
			$sfx_close.connect("finished", queue_free, 4)
			$sfx_close.play()
			visible = false
			#queue_free()
	pass

func quit_game():
	#get_tree().quit()
	get_tree().paused = false
	AudioManager.fade_out_music()
	ModeManager.end_game(false)
	return_to_menu.call_deferred()
	pass # Replace with function body.

func open_settings():
	var s = load("res://System/SettingsMenu.tscn").instantiate()
	add_child(s)
	s.connect("on_queue_exit", close_settings)
	process_mode = Node.PROCESS_MODE_DISABLED
	$VBoxContainer.visible = false

func close_settings():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$VBoxContainer.visible = true
	$VBoxContainer/btn_Settings.grab_focus()
	pass

func return_to_menu():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
