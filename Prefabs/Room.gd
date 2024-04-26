extends Node3D

var roomData = {}

func _ready():
	if not GameDataManager.room_discovered(name):
		initialize_room_state()
		GameDataManager.update_room(name, get_data())
	else:
		#load data for room
		pass
	pass

func initialize_room_state():
	roomData["id"] = name
	roomData["challenges"] = {}
	roomData["doors"] = {}

func get_data():
	return roomData
