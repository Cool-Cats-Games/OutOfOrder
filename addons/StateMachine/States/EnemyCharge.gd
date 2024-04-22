extends State

signal timeout

@export var waitTime = 1.0
@export var oneShot = false

var timer = Timer.new()
var target = null

func _ready():
	add_child(timer)
	timer.timeout.connect(on_timeout)

func enter(_msg := {}) -> void:
	super.enter(_msg)
	target = actor.target
	actor.localInputVector = Vector3.ZERO
	timer.one_shot = oneShot
	timer.start(waitTime)
	print($"../../TommyTwoTraps/AnimationPlayer".get_animation_list())
	pass

func physics_update(_delta: float) -> void:
	var dir = actor.global_position.direction_to(target.global_position)
	var gt = Transform3D()
	gt = gt.translated(actor.global_position)
	gt = gt.looking_at(target.global_position)
	actor.uprightQuat = Quaternion(gt.basis)

func test_exit(target_state_name) -> bool:
	return target_state_name == "Launch"

func on_timeout():
	state_machine.transition_to("Launch")
