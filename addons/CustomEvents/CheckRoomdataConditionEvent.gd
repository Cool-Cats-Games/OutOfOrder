extends "res://addons/CustomEvents/GenericEvent.gd"

@export var parameters = {}

@export var matchValue = true #if unchecked, it only needs the parameter to exist
@export var invert = false #will only fire if it fails the check
@export var requireAll = true #if true, all the parameters need to exist, otherwise will fire if any are valid

func _ready():
	super._ready()
	add_to_group("Roomstate")

func on_room_loaded(room):
	for p in parameters:
		var test = test_param(room.get_data(), p, parameters[p])
		if test and not requireAll:
			trigger()
			return
		elif not test and requireAll:
			return
	trigger()
	pass

func test_param(data, par, val):
	if data.has(par):
		if not matchValue: return true if not invert else false
		if invert: return data[par] != val
		return data[par] == val
	elif invert: return true
	return false
