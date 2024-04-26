extends State

var ipVis = null
var firstFrame = false

func enter(_msg := {}) -> void:
	super.enter(_msg)
	ipVis = actor.mainCamera.get_node("inputVisual")
	$"../../sfx_movement".pitch_scale = randf_range(0.9,1.1)
	$"../../sfx_start_move".pitch_scale = randf_range(0.9,1.0)
	$"../../sfx_stop_move".pitch_scale = randf_range(0.9,1.0)
	#if not $"../../sfx_start_move".playing and randf() < 0.5:
		#$"../../sfx_start_move".play()
	firstFrame = true
	pass

func exit():
	super.exit()
	if not $"../../sfx_stop_move".playing and randf() < 0.5:
		$"../../sfx_stop_move".play()

func update(_delta: float) -> void:
	if Input.is_action_just_pressed("jump") and actor.is_on_ground():
		state_machine.transition_to("Jump")
	if Input.is_action_just_pressed("boost") and actor.canBoost:
		state_machine.transition_to("Boost")
	if Input.is_action_just_pressed("shoot") and actor.cream > 0.0:
		state_machine.transition_to("Creaming")
	if Input.is_action_just_pressed("light_attack"):
		if $"../../Landed".is_colliding():
			state_machine.transition_to("LightAttack")
		else:
			state_machine.transition_to("SlamAttack")
	pass

func physics_update(_delta: float) -> void:
	var inputDir = Vector3.ZERO
	inputDir.x = Input.get_axis("move_right", "move_left")
	inputDir.z = Input.get_axis("move_back", "move_forward")
	actor.localInputVector = inputDir.rotated(Vector3.UP, actor.mainCamera.rotation.y)
	if firstFrame:
		if actor.linear_velocity.dot(actor.localInputVector) < 0.5:
			if not $"../../sfx_start_move".playing:
				$"../../sfx_start_move".play()
		firstFrame = false
	ipVis.position = ipVis.position.lerp(inputDir * 2, 1.0)
	if inputDir.length() > 0.2:
		var ang = atan2(actor.localInputVector.x, actor.localInputVector.z)
		actor.rotation.y = ang
	else:
		state_machine.transition_to("Idle")
	pass
