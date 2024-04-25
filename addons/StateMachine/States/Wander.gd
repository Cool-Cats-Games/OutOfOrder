extends State


func enter(_msg := {}) -> void:
	super.enter(_msg)
	actor.isPatrolling = false
	actor.walk_to(actor.global_position + (Vector3(randf_range(-1.0,1.0), 0.0, randf_range(-1.0,1.0)) * randf_range(5.0,10.0)))
