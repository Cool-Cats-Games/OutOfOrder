extends State

var ipVis = null

func enter(_msg := {}) -> void:
	super.enter(_msg)
	ipVis = actor.mainCamera.get_node("inputVisual")
	pass

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and actor.is_on_ground():
		state_machine.transition_to("Jump")
	if Input.is_action_just_pressed("boost") and actor.canBoost:
		state_machine.transition_to("Boost")
	pass

func physics_update(_delta: float) -> void:
	var inputDir = Vector3.ZERO
	inputDir.x = Input.get_axis("move_right", "move_left")
	inputDir.z = Input.get_axis("move_back", "move_forward")
	actor.localInputVector = inputDir.rotated(Vector3.UP, actor.mainCamera.rotation.y)
	ipVis.position = ipVis.position.lerp(inputDir * 2, 1.0)
	if inputDir.length() > 0.2:
		var ang = atan2(actor.localInputVector.x, actor.localInputVector.z)
		actor.rotation.y = ang
	else:
		state_machine.transition_to("Idle")
	pass
