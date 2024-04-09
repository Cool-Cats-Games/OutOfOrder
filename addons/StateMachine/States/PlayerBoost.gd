extends State

func enter(_msg = {}):
	super.enter(_msg)
	print("boosting")

func physics_update(_delta):
	actor.apply_force(actor.transform.basis.z * actor.boostSpeed)
	actor.boost -= 3.0
	if actor.boost <= 0.0:
		actor.boost = 0.0
		actor.canBoost = false
		state_machine.transition_to("Idle")
