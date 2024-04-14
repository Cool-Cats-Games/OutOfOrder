extends State

func enter(_msg := {}) -> void:
	super.enter(_msg)
	actor.localInputVector = Vector3.ZERO
	pass

func update(_delta: float) -> void:
	if actor.target != null:
		state_machine.transition_to("Chase")
	pass
