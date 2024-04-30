extends "res://addons/CustomEvents/CounterEvent.gd"

@export var entity_type = ""

func on_enemy_death(e):
	test(e)

func on_breakable_smashed(e):
	test(e)

func test(e):
	if not entity_type == "":
		if e.entity_type == entity_type:
			increment()
	else:
		increment()
