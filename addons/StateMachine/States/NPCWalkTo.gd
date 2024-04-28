extends State

signal on_walk_to_reached

@export var threshold = 1.0

var points = []
var framesStuck = 0
var maxFramesStuck = 25


func enter(_msg := {}) -> void:
	super.enter(_msg)
	points = _msg.points
	actor.play_animation("Walk" if stateAnimationName == "" else stateAnimationName)
	framesStuck = 0

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	var dir = actor.global_position.direction_to(points.front())
	var gt = Transform3D()
	gt = gt.translated(actor.global_position)
	gt = gt.looking_at(Vector3(points.front().x, actor.position.y, points.front().z))
	actor.uprightQuat = Quaternion(gt.basis)
	actor.localInputVector = dir
	var dist = actor.global_position.distance_to(points.front())
	if dist < threshold:
		points.pop_front()
		if points.size() == 0:
			state_machine.transition_to("Idle")
			if not actor.isPatrolling:
				on_walk_to_reached.emit()
	if actor.linear_velocity.length() < 0.1:
		framesStuck += 1
	if framesStuck > maxFramesStuck:
		state_machine.transition_to("Idle")
	pass
