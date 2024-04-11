extends State


var ipVis = null
var initialRH
var initialCT

var startingHover

func enter(_msg := {}) -> void:
	super.enter(_msg)
	ipVis = actor.mainCamera.get_node("inputVisual")
	actor.toggle_hover(true)
	initialRH = actor.rideHeight
	initialCT = actor.get_node("FloorCast").target_position.y
	actor.maxSpeed *= 0.5
	
	actor.get_node("FloorCast").target_position.y = min(-3.0, -actor.position.y - 1.5)
	#actor.rideHeight = (actor.rideHeight * 2.0) + actor.get_node("FloorCast").get_collision_point().y
	actor.rideHeight *= 2.0
	print("(hovering) RH: ", actor.rideHeight, " - floor: ", actor.get_node("FloorCast").get_collision_point().y)
	#actor.rideSpringScaler = 0.0
	actor.gravity_scale = -0.15
	pass
	
func exit():
	super.exit()
	actor.gravity_scale = 1.0
	actor.toggle_hover(false)
	actor.maxSpeed *= 2.0
	actor.rideHeight = initialRH
	actor.get_node("FloorCast").target_position.y = initialCT
	actor.rideSpringScaler = 1.0

func update(_delta: float) -> void:
	actor.cream -= 1.5
	if Input.is_action_just_released("jump") or actor.cream <= 0.0:
		state_machine.transition_to("Idle")
	pass

func physics_update(_delta: float) -> void:
	var inputDir = Vector3.ZERO
	actor.rideSpringScaler = lerp(actor.rideSpringScaler, 0.0, 0.1)
	inputDir.x = Input.get_axis("move_right", "move_left")
	inputDir.z = Input.get_axis("move_back", "move_forward")
	actor.localInputVector = inputDir.rotated(Vector3.UP, actor.mainCamera.rotation.y)
	ipVis.position = ipVis.position.lerp(inputDir * 2, 1.0)
	if inputDir.length() > 0.2:
		var ang = atan2(actor.localInputVector.x, actor.localInputVector.z)
		actor.rotation.y = ang
	
	pass

