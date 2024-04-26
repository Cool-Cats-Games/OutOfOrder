extends Area3D

enum State {open, locked, disabled}

@export var requires = ""
@export var targetRoom = ""

var initialState
var state = State.open


func _ready():
	$Status.hide()
	$MeshInstance3D.hide()
	if requires != "":
		state = State.locked
	initialState = state

func set_state(s = State.open):
	state = s
	match  state:
		State.open:
			$Status.texture = load("res://Sprites/UI/BoardGameIcons(x64)/arrow_up.png")
		State.locked:
			$Status.texture = load("res://Sprites/UI/BoardGameIcons(x64)/lock_closed.png")
		State.disabled:
			$Status.texture = load("res://Sprites/UI/BoardGameIcons(x64)/Blocked.png")

func get_facing_dir():
	return $MeshInstance3D.global_position.direction_to(global_position)

func report_state(room):
	room.update_door(self)

func _on_body_entered(body):
	$Status.show()
	#test state for moving to next area
	if state == State.open:
		GameDataManager.gameData.doorName = name
		var room = get_tree().get_first_node_in_group("World")
		room.update_state()
		room.save_room_data()
		get_tree().change_scene_to_file(targetRoom)
	pass # Replace with function body.


func _on_body_exited(body):
	$Status.hide()
	pass # Replace with function body.
