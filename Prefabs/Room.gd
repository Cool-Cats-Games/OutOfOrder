extends Node3D

var roomData = {}

func _ready():
	if not GameDataManager.room_discovered(name):
		initialize_room_state()
		update_state()
		save_room_data()
	else:
		load_room_data()
	get_tree().call_group("Roomstate", "on_room_loaded", self)
	pass

func initialize_room_state():
	roomData["id"] = name
	roomData["challenges"] = {}
	roomData["doors"] = {}
	roomData["hasGoldenCat"] = false

func get_data():
	return roomData

func load_room_data():
	roomData = GameDataManager.gameData.rooms[name]

func save_room_data():
	GameDataManager.update_room(name, get_data())

func set_room_data(param, value):
	roomData[param] = value

func update_door(door):
	roomData["doors"][door.name] = door.state

func update_challenge(c):
	roomData["challenges"][c.name] = c.isCompleted

func update_state():
	get_tree().call_group("Doors", "report_state", self)
	get_tree().call_group("Challenges", "report_state", self)
