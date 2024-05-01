extends Node3D

var roomData = {}

func _ready():
	WildBackground.get_child(0).generate_new_background()
	if not GameDataManager.room_discovered(name):
		initialize_room_state()
		update_state()
		save_room_data()
	else:
		load_room_data()
		parse_deleted_nodes()
	get_tree().call_group("Roomstate", "on_room_loaded", self)
	pass

func initialize_room_state():
	roomData["id"] = name
	roomData["challenges"] = {}
	roomData["doors"] = {}
	roomData["hasGoldenCat"] = false
	roomData["deletedInstances"] = []

func get_data():
	return roomData

func load_room_data():
	roomData = GameDataManager.gameData.rooms[name]

func parse_deleted_nodes():
	for n in roomData.deletedInstances:
		var nobj = get_node(n)
		if is_instance_valid(nobj):
			nobj.queue_free()

func register_instance_deleted(path):
	if not roomData.deletedInstances.has(path):
		roomData.deletedInstances.append(path)

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


func set_gravity_scale(extra_arg_0):
	pass # Replace with function body.


func toggle_force_integration(extra_arg_0):
	pass # Replace with function body.
