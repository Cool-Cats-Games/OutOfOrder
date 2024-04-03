extends CanvasLayer

signal on_exit_queued()

var exitBuffer = false
var curLayout = 0

func _process(delta):
	if Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_bumper_right") or Input.is_action_just_pressed("ui_rightstick_right"):
		next_layout(1)
	elif Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_bumper_left") or Input.is_action_just_pressed("ui_rightstick_left"):
		next_layout(-1)
	if Input.is_action_just_pressed("ui_cancel") and not exitBuffer:
		exitBuffer = true
	elif exitBuffer:
		emit_signal("on_exit_queued")
		queue_free()

func next_layout(dir = 1):
	update_layout_shown(false)
	curLayout = wrap(curLayout + dir, 0, 2)
	update_layout_shown(true)
	pass

func update_layout_shown(state):
	match curLayout:
		0:
			$GamepadControls.visible = state
			$VBoxContainer/HBoxContainer2/Label.text = " Gamepad"
		1:
			$MouseKeyboardControls.visible = state
			$VBoxContainer/HBoxContainer2/Label.text = " Mouse & Keyboard"
	$sfxlayoutchange.play()
