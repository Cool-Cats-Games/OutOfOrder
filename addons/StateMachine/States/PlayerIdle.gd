extends State

var inputDir : Vector3

func enter(_msg := {}) -> void:
	super.enter(_msg)
	actor.localInputVector = Vector3.ZERO
	pass

func update(_delta: float) -> void:
	inputDir.x = Input.get_axis("move_right", "move_left")
	inputDir.z = Input.get_axis("move_back", "move_forward")
	if inputDir.length() > 0.1:
		state_machine.transition_to("Move")
	if Input.is_action_just_pressed("jump") and actor.is_on_ground():
		state_machine.transition_to("Jump")
	if Input.is_action_just_pressed("shoot") and actor.cream > 0.0:
		state_machine.transition_to("Creaming")
	pass