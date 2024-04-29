extends "res://addons/CustomEvents/GenericEvent.gd"

@export var scene : PackedScene

func trigger(by = null):
	super.trigger(by)
	get_tree().change_scene_to_packed(scene)
	pass # Replace with function body.
