extends State

var fleeingFromPoint
var framesStuck = 0
var maxFramesStuck = 25

func enter(_msg := {}) -> void:
	super.enter(_msg)
	actor.maxSpeed = 6.4
	fleeingFromPoint = _msg["from"]
	actor.play_animation("Flee")
	framesStuck = 0

func physics_update(_delta: float) -> void:
	var dir = fleeingFromPoint.direction_to(actor.global_position)
	dir.y = fleeingFromPoint.y
	var gt = Transform3D()
	gt = gt.translated(actor.global_position)
	gt = gt.looking_at(Vector3(fleeingFromPoint.x, actor.position.y, fleeingFromPoint.z))
	gt = gt.rotated_local(Vector3.UP, deg_to_rad(180))
	actor.uprightQuat = Quaternion(gt.basis)
	actor.localInputVector = dir * 2.0
	var dist = actor.global_position.distance_to(fleeingFromPoint)
	if actor.linear_velocity.length() < 0.1:
		framesStuck += 1
	if framesStuck > maxFramesStuck:
		state_machine.transition_to("Idle")
	pass
