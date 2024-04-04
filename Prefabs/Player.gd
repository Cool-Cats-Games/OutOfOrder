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

var speed = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	floorCast.rotation = rotation * -1
	apply_force(floorCast.target_position * get_spring_force())
	var inputDir = Vector3.ZERO
	inputDir.x = Input.get_axis("move_left","move_right")
	inputDir.z = Input.get_axis("move_forward","move_back")
	var unitInput = inputDir.normalized()
	var goalVel = unitInput * maxSpeed
	var stepVel = linear_velocity.lerp(goalVel, acceleration * 0.5)
	if Input.is_action_just_pressed("jump") and floorCast.is_colliding():
		apply_force(Vector3.UP * jumpSpeed)
	apply_force(stepVel * mass)
	correct_upright_force()


func correct_upright_force():
	var charCurrentRotation = quaternion
	var goalQuaternion = uprightQuat.slerp(charCurrentRotation, 1.0)
	var rotAngle = goalQuaternion.get_angle()
	var rotAxis = goalQuaternion.get_axis()
	print(rotAngle, "on: ", rotAxis)
	apply_torque((rotAxis * (-rotAngle * uprightSpringStrength)) - (angular_velocity * uprightSpringDampener))
	

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
