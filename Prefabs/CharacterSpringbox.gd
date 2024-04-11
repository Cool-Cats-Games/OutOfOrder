extends RigidBody3D

#@onready var floorCast = $"../FloorCast"
@onready var floorCast = $FloorCast
@onready var uprightQuat = quaternion
@onready var player = get_tree().get_first_node_in_group("Player")

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
var speed = 1.0
var facingPoint = Vector3.ZERO
var rotAng = 0.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	get_main_camera()

func _integrate_forces(state):
	floorCast.rotation = rotation * -1
	position = player.position
	correct_upright_force()

func correct_upright_force():
	var charCurrentRotation = quaternion
	var goalQuaternion = ShortestRotation(player.quaternion, charCurrentRotation)
	var rotAngle = goalQuaternion.get_angle()
	var rotAxis = goalQuaternion.get_axis().normalized()
	apply_torque((rotAxis * (rotAngle * uprightSpringStrength)) - (angular_velocity * uprightSpringDampener))

func get_main_camera():
	mainCamera = get_tree().get_first_node_in_group("MainCamera")

func ShortestAngleDist(from : float, to : float) -> float:
	var maxAngle = PI * 2.0
	var difference =  fmod((to - from), maxAngle)
	return fmod((2 * difference), maxAngle) - difference

func ShortestRotation(to : Quaternion, from : Quaternion) -> Quaternion:
	if to.dot(from) < 0:
		return to * (from * -1).inverse()
	else:
		return to * from.inverse()
