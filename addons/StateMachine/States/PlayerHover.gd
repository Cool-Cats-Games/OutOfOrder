extends State


var ipVis = null

func enter(_msg := {}) -> void:
	super.enter(_msg)
	ipVis = actor.mainCamera.get_node("inputVisual")
	actor.toggle_hover(true)
	actor.maxSpeed *= 0.5
	actor.rideHeight *= 2.0
	actor.get_node("FloorCast").target_position.y = -3.0
	pass
	
func exit():
	super.exit()
	actor.toggle_hover(false)
	actor.maxSpeed *= 2.0
	actor.rideHeight *= 0.5
	actor.get_node("FloorCast").target_position.y = -1.5

func update(_delta: float) -> void:
	actor.cream -= 1.5
	if Input.is_action_just_released("jump") or actor.cream <= 0.0:
		state_machine.transition_to("Idle")
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
	pass

