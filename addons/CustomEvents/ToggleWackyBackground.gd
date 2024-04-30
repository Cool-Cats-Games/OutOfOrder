extends "res://addons/CustomEvents/GenericEvent.gd"

@export var enable = true

func trigger(by = null):
	super.trigger(by)
	get_tree().call_group("BackgroundLayer", ("show" if enable else "hide"))
