extends "res://addons/CustomEvents/GenericEvent.gd"

@export var count = 0
@export var goal = 10

func increment(by = 1):
	count += 1
	if count >= goal:
		trigger()

func decrement(by = 1):
	count -= 1
	if count <= goal:
		trigger()


