extends RigidBody3D


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

var creamSplatterRef
var mainCamera = null
var speed = 1.0
var facingPoint = Vector3.ZERO
var projectileRef = preload("res://Prefabs/CreamProjectile.tscn")
var rotAng = 0.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	get_main_camera()
	player.characterModel = self
	creamSplatterRef = get_tree().get_first_node_in_group("EFX_CreamSplatter")

func _integrate_forces(state):
	if not is_instance_valid(player):
		return
	floorCast.rotation = rotation * -1
	position = player.position
	correct_upright_force()

func correct_upright_force():
	var charCurrentRotation = quaternion
	var goalQuaternion = Utils.ShortestRotation(player.quaternion, charCurrentRotation)
	var rotAngle = goalQuaternion.get_angle()
	var rotAxis = goalQuaternion.get_axis().normalized()
	apply_torque((rotAxis * (rotAngle * uprightSpringStrength)) - (angular_velocity * uprightSpringDampener))

func get_main_camera():
	mainCamera = get_tree().get_first_node_in_group("MainCamera")


func launch(dir, isR = true):
	var gp = projectileRef.instantiate()
	Utils.get_world(get_tree()).add_child(gp)
	gp.position = $NozzlePointR.global_position if isR else $NozzlePointL.global_position
	var launchDir = global_transform.basis.z
	gp.launch(launchDir + Vector3.UP * 0.3, gp.position + basis.z + Vector3.UP * 0.1, creamSplatterRef, player)

func play_animation(animName):
	$AnimationPlayer.play(animName)

func ShortestAngleDist(from : float, to : float) -> float:
	var maxAngle = PI * 2.0
	var difference =  fmod((to - from), maxAngle)
	return fmod((2 * difference), maxAngle) - difference

func toggle_ice_stream(enabled = true):
	$IceStream.emitting = enabled
	$IceStream2.emitting = enabled
	$CreamHitbox.monitoring = enabled
	$CreamHitbox/CreamSplatters.toggle(enabled)

func toggle_movement_particles(s = true):
	$MovementParticles.emitting = s
