extends Node2D

var buttonRef = null
var isListening = false

func cancel():
	deselect()
	$sfx_cancel.play()

func confirm():
	buttonRef.on_confirm.emit()
	deselect()
	$sfx_confirm.play()

func deselect():
	if buttonRef:
		buttonRef.deselect()
	buttonRef = null
	$AnimationPlayer.play("Close")

func initialize(btn):
	if buttonRef != null:
		buttonRef.deselect()
	buttonRef = btn
	isListening = false
	$AnimationPlayer.play("default")
	$sfx_open.play()

func _process(delta):
	if isListening and buttonRef != null:
		if Input.is_action_just_pressed("ui_accept"):
			confirm()
		elif Input.is_action_just_pressed("ui_cancel"):
			cancel()

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"default":
			isListening = true
	pass # Replace with function body.
