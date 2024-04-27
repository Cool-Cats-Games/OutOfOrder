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
	actor.gravity_scale = -0.18
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
	if Input.is_action_just_released("jump"):
		state_machine.transition_to("Idle", {"startingInAir": true})
	if actor.cream <= 0.0:
		$"../../sfx_outOfCream".play()
		state_machine.transition_to("Idle", {"startingInAir": true})
	if Input.is_action_just_pressed("light_attack"):
		state_machine.transition_to("SlamAttack")
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
	if $"../../IceCreamHoverCast".is_colliding():
		var e = $"../../IceCreamHoverCast".get_collider()
		if e.has_method("take_damage"):
			e.take_damage(2, actor.global_position.direction_to(e.global_position), actor)
	pass

