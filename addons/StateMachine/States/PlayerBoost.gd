extends State

func enter(_msg = {}):
	super.enter(_msg)
	print("boosting")
	$"../../ActiveHitbox".monitoring = true
	get_tree().get_first_node_in_group("MainCamera").set_fov(90.0)

func exit():
	super.exit()
	get_tree().get_first_node_in_group("MainCamera").set_fov(75.0)
	$"../../ActiveHitbox".monitoring = false

func physics_update(_delta):
	actor.apply_force(actor.transform.basis.z * actor.boostSpeed)
	actor.boost -= 3.0
	if actor.boost <= 0.0:
		actor.boost = 0.0
		actor.canBoost = false
		state_machine.transition_to("Idle")