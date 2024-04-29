extends "res://addons/CustomEvents/GenericEvent.gd"

enum InputTypes {JustPressed, Pressed, JustReleased, Released}

@export var action : String
@export var listenType : InputTypes

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match listenType:
		InputTypes.JustPressed:
			if Input.is_action_just_pressed(action):
				trigger()
		InputTypes.Pressed:
			if Input.is_action_pressed(action):
				trigger()
		InputTypes.JustReleased:
			if Input.is_action_just_released(action):
				trigger()
		InputTypes.Released:
			if Input.is_action_just_released(action):
				trigger()
	pass
