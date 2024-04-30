extends "res://addons/CustomEvents/GenericEvent.gd"

#array of paths to the challenge resource to load as strings
@export var challenges : Array[String]
@export var blockDoors = true

func trigger(by = null):
	super.trigger(by)
	load_challenge.call_deferred()

func load_challenge():
	var pick = challenges.pick_random()
	var res = load(pick).instantiate()
	Utils.get_world(get_tree()).add_child(res)
	res.global_position = global_position
	res.lock_rooms_on_start = blockDoors
	if res.autostart:
		res.start_challenge.call_deferred()
