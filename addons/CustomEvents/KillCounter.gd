extends "res://addons/CustomEvents/CounterEvent.gd"

@export var entity_type = ""

func on_enemy_death(e):
	if not entity_type == "":
		if e.entity_type:
			increment()
	else:
		increment()
