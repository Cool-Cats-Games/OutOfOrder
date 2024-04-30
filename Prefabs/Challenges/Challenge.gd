extends Node3D

signal on_challenge_start()
signal on_challenge_complete()

@export var autostart = false
@export var emblemRes : Resource
@export var lock_rooms_on_start = true


var hasStarted = false
var isCompleted = false

func _ready():
	add_to_group("Challenges")
	add_to_group("Roomstate")
	#if autostart:
		#start_challenge.call_deferred()

func complete():
	if hasStarted:
		isCompleted = true
		on_challenge_complete.emit()
		get_tree().call_group("ChallengeEmblems", "complete_challenge", self)

func get_emblem():
	return emblemRes

func on_room_loaded(room):
	isCompleted = room.roomData.challenges[name]
	if autostart and not isCompleted:
		start_challenge.call_deferred()

func report_state(room):
	room.update_challenge(self)

func start_challenge():
	hasStarted = true
	on_challenge_start.emit()
	#lock all doors until challenge completed if lock_rooms is true
	if lock_rooms_on_start:
		get_tree().call_group("Doors", "set_state", 2)
	#load challenge ico on HUD
	get_tree().call_group("ChallengeEmblems", "add_challenge", self)
	for c in get_children():
		if c.has_method("play_playlist"):
			c.play_playlist()

func update_emblem(_msg = {}):
	if hasStarted:
		get_tree().call_group("ChallengeEmblems", "update_emblem", self, _msg)
	
