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

var mainCamera = null
var speed = 0.0
var facingPoint = Vector3.ZERO
var rotAng = 0.0


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
	var localInputVector = inputDir.rotated(Vector3.UP, mainCamera.rotation.y)
	var ipVis = mainCamera.get_node("inputVisual")
	ipVis.position = ipVis.position.lerp(inputDir * 2, 1.0)
	var unitInput = localInputVector.normalized()
	var goalVel = unitInput * maxSpeed
	var stepVel = linear_velocity.lerp(goalVel, acceleration)
	if Input.is_action_just_pressed("jump") and floorCast.is_colliding():
		apply_force(Vector3.UP * jumpSpeed)
	apply_force(stepVel * mass)
	if inputDir.length() > 0.5:
		uprightQuat = Quaternion(mainCamera.global_transform.looking_at(mainCamera.global_position - (inputDir * 30.0)).basis)
	correct_upright_force()



func correct_upright_force():
	var charCurrentRotation = quaternion
	var goalQuaternion = charCurrentRotation - uprightQuat
	var rotAngle = goalQuaternion.get_angle()
	var rotAxis = goalQuaternion.get_axis()
	print("upright:",uprightQuat.get_euler(), "goal:",goalQuaternion.get_euler(), "charQuat: ",charCurrentRotation.get_euler())
	apply_torque((rotAxis * (-rotAngle * uprightSpringStrength)) - (angular_velocity * uprightSpringDampener))

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

