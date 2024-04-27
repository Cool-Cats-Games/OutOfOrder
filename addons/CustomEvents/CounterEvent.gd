extends "res://addons/CustomEvents/GenericEvent.gd"

signal on_increment()
signal on_decrement()
signal on_count_changed(count, goal)

@export var count = 0
@export var goal = 10

func increment(by = 1):
	count += 1
	on_increment.emit()
	on_count_changed.emit(count, goal)
	if count >= goal:
		trigger()

func decrement(by = 1):
	count -= 1
	on_decrement.emit()
	on_count_changed.emit(count, goal)
	if count <= goal:
		trigger()


