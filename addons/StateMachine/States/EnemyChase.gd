extends State

@export var chaseThreshold = 3.0

func update(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	var dir = actor.global_position.direction_to(actor.target.global_position)
	var gt = Transform3D()
	gt = gt.translated(actor.global_position)
	gt = gt.looking_at(actor.target.global_position)
	actor.uprightQuat = Quaternion(gt.basis)
	actor.localInputVector = dir
	var dist = actor.global_position.distance_to(actor.target.global_position)
	if dist < chaseThreshold:
		on_chase_threshold_reached()
	pass

func on_chase_threshold_reached():
	state_machine.transition_to("Charge")

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	super.enter(_msg)
	$"../../AggroRange/CollisionShape3D".shape.radius = 10.0
	pass

func exit():
	super.exit()
	$"../../AggroRange/CollisionShape3D".shape.radius = 5.0

