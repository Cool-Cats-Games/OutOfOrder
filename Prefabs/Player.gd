extends RigidBody3D

@onready var floorCast = $FloorCast
@onready var uprightQuat = quaternion

@export var acceleration = 1.0
@export var jumpSpeed = 700
@export var rideHeight = 5.0
@export var rideSpringDamper = 0.5
@export var rideSpringStrength = 1.0
@export var maxAccelerationForce = 150
@export var maxSpeed = 8.0
@export var uprightSpringStrength = 30.0
@export var uprightSpringDampener = 4.0



var facingPoint = Vector3.ZERO
var localInputVector = Vector3()
var mainCamera = null
var rotAng = 0.0
var speed = 0.0
var ticks = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	get_main_camera()

func _physics_process(delta):
	floorCast.rotation = rotation * -1
	apply_force(floorCast.target_position * get_spring_force())
	var inputDir = Vector3.ZERO
	inputDir.x = Input.get_axis("move_right", "move_left")
	inputDir.z = Input.get_axis("move_back", "move_forward")
	localInputVector = inputDir.rotated(Vector3.UP, mainCamera.rotation.y)
	var ipVis = mainCamera.get_node("inputVisual")
	ipVis.position = ipVis.position.lerp(inputDir * 2, 1.0)
	var unitInput = localInputVector.normalized()
	var goalVel = unitInput * maxSpeed
	var stepVel = linear_velocity.lerp(goalVel, acceleration)
	ticks += 0.1 + 0.1 * abs(inputDir.length())
	rideHeight = 1.2 + sin(ticks) * (0.05 + 0.1* abs(inputDir.length()))
	if Input.is_action_just_pressed("jump") and floorCast.is_colliding():
		apply_force(Vector3.UP * jumpSpeed)
	apply_force(stepVel * mass)
	if inputDir.length() > 0.5:
		var ang = atan2(localInputVector.x, localInputVector.z)
		rotation.y = ang

func get_desired_movement():
	return localInputVector

func get_main_camera():
	mainCamera = get_tree().get_first_node_in_group("MainCamera")

func get_spring_force():
	var vel = linear_velocity
	var raydir = floorCast.target_position
	var othervel = Vector3.ZERO
	if floorCast.is_colliding():
		$MeshInstance3D3.global_position.y = floorCast.get_collision_point().y + 0.05
		var col = floorCast.get_collider()
		if "constant_linear_velocity" in col:
			othervel = col.constant_linear_velocity
		elif "linear_velocity" in col:
			othervel = col.linear_velocity
		elif "velocity" in col:
			othervel = col.velocity
	var rayDirVel = raydir.dot(vel)
	var otherDirVel = raydir.dot(othervel)
	var relvel = rayDirVel - otherDirVel
	var x = global_position.distance_to(floorCast.get_collision_point()) - rideHeight
	var springforce = (x * rideSpringStrength) - (rayDirVel * rideSpringDamper)
	return springforce

