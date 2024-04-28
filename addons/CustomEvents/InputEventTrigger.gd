extends "res://addons/CustomEvents/GenericEvent.gd"

@export var actionName = ""

func _process(delta):
	if Input.is_action_just_pressed(actionName):
		trigger()
