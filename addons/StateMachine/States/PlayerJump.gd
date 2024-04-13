extends State

var jumpReleased = false
var hasLeftGround = false
var ipVis = null


func enter(_msg := {}) -> void:
	super.enter(_msg)
	ipVis = actor.mainCamera.get_node("inputVisual")
	actor.apply_force(Vector3.UP * actor.jumpSpeed)
	hasLeftGround = false
	pass

func update(_delta: float) -> void:
	if Input.is_action_just_released("jump") and not jumpReleased:
		jumpReleased = true
	if Input.is_action_just_pressed("jump") and actor.cream > 0.0:
		state_machine.transition_to("Hover")
	pass

func physics_update(_delta: float) -> void:
	if not actor.is_on_ground() and not hasLeftGround:
		hasLeftGround = true
		actor.isOffGround = true
	if actor.is_on_ground() and hasLeftGround:
		state_machine.transition_to("Idle")
		#$"../../sfx_land".play_random()
	pass
