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
		set_state(State.locked)
	initialState = state

func set_state(s = State.open):
	state = s
	match  state:
		State.open:
			$Status.texture = load("res://Sprites/UI/BoardGameIcons(x64)/arrow_up.png")
			$Status/Status2.texture = load("res://Sprites/UI/BoardGameIcons(x64)/arrow_up.png")
		State.locked:
			$Status.texture = load("res://Sprites/UI/BoardGameIcons(x64)/lock_closed.png")
			$Status/Status2.texture = load("res://Sprites/UI/BoardGameIcons(x64)/lock_closed.png")
		State.disabled:
			$Status.texture = load("res://Sprites/UI/BoardGameIcons(x64)/Blocked.png")
			$Status/Status2.texture = load("res://Sprites/UI/BoardGameIcons(x64)/Blocked.png")

func get_facing_dir():
	return $MeshInstance3D.global_position.direction_to(global_position)

func on_room_loaded(room):
	set_state(room.roomData.doors[name])

func report_state(room):
	room.update_door(self)

func trigger(by = null):
	GameDataManager.gameData.doorName = name
	var room = get_tree().get_first_node_in_group("World")
	room.update_state()
	room.save_room_data()
	get_tree().change_scene_to_file(targetRoom)

func _on_body_entered(body):
	$Status.show()
	#test state for moving to next area
	if state == State.open:
		trigger()
	elif state == State.locked:
		var hasKey = GameDataManager.gameData.inventory.has(requires)
		if hasKey:
			$AnimationPlayer.play("unlock")
		else:
			$sfx_locked.play()
	pass # Replace with function body.


func _on_body_exited(body):
	if not $AnimationPlayer.is_playing():
		$Status.hide()
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	$Status.modulate = Color(1,1,1,1)
	$Status.hide()
	set_state(State.open)
	
	if get_overlapping_bodies().size() > 0:
		trigger()
	pass # Replace with function body.
