extends State

var fleeingFromPoint

func enter(_msg := {}) -> void:
	super.enter(_msg)
	actor.maxSpeed = 6.4
	fleeingFromPoint = _msg["from"]

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
	pass
