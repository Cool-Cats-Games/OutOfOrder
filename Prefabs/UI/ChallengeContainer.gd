extends Node2D

var activeChallenges = {}

func add_challenge(challengeRef):
	var ce = challengeRef.get_emblem().instantiate()
	add_child(ce)
	ce.initialize(get_child_count() - 1)
	ce.position.x = 1000
	activeChallenges[challengeRef] = ce

func complete_challenge(c):
	set_status(c, 1)
	for ace in activeChallenges:
		if not ace.isCompleted: return
	#enable all doors
	for d in get_tree().get_nodes_in_group("Doors"):
		d.set_state(d.initialState)

func set_status(challenge, s):
	activeChallenges[challenge].set_status(s)

func update_emblem(challenge, _msg = {}):
	activeChallenges[challenge].update(_msg)
