extends State


func enter(_msg := {}) -> void:
	super.enter(_msg)
	actor.apply_force(Vector3(0,-50,0))
	actor.linear_velocity = Vector3(0,-20,0)
	actor.position += Vector3(0,1,0)


func physics_update(_delta: float) -> void:
	if $"../../Landed".is_colliding():
		state_machine.transition_to("SlamLag")
	pass


