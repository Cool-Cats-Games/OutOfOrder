extends State

func enter(_msg := {}) -> void:
	super.enter(_msg)
	actor.isPatrolling = true
	get_tree().call_group("PatrolPath", "give_path_to", actor)
