extends "res://addons/CustomEvents/GenericEvent.gd"

@export var group : String
@export var methodname : String
@export var vargs : Array[Variant]

func _on_on_trigger(by):
	get_tree().call_group(group, "callv", methodname, vargs)
	pass # Replace with function body.
