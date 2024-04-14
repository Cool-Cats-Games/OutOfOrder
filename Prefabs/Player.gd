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


var boost = 50.0
var boostMax = 50.0
var boostRegen = 0.5
var boostSpeed = 60.0
var canBoost = true
var cream = 100.0
var creamMax = 100.0
var creamRegen = 0.5
var facingPoint = Vector3.ZERO
var localInputVector = Vector3()
var mainCamera = null
var rideSpringScaler = 1.0
var rotAng = 0.0
var speed = 0.0
var ticks = 0

var isOffGround = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	get_main_camera()

func _process(_delta):
	if (canBoost and not Input.is_action_pressed("boost")) or not canBoost:
		boost = clamp(boost + boostRegen, 0.0, boostMax)
		if boost == boostMax:
			canBoost = true
	var is_at_cream = cream == creamMax
	cream = clamp(cream + creamRegen, 0.0, creamMax)
	if not is_at_cream and cream == creamMax:
		$sfx_creamReady.play()
	if isOffGround and $Landed.is_colliding() and $StateMachine.get_state_name() != "Hover":
		isOffGround = false
		$sfx_land.play_random()
	pass

func _integrate_forces(state):
	floorCast.rotation = rotation * -1
	apply_force(floorCast.target_position * get_spring_force())
	var unitInput = localInputVector.normalized()
	var goalVel = unitInput * maxSpeed
	var stepVel = linear_velocity.lerp(goalVel, acceleration)
	apply_force(stepVel * mass)
	speed = abs(Vector3(linear_velocity.x, 0.0, linear_velocity.z).length())

func get_cream_damage():
	return 1.0

func get_ice_cream_fv():
	return cream / creamMax

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
	if floorCast.is_colliding():
		var body = floorCast.get_collider()
		if body.has_method("apply_force"):
			body.apply_force(-1.0 * floorCast.target_position * springforce)
	return springforce * rideSpringScaler

func play_sound(stream):
	$sfx_player_generic.stream = stream
	$sfx_player_generic.play()

func toggle_hover(s = true):
	$"../CharacterSpringbox/IcecreamHover".emitting = s
	$"../CharacterSpringbox/IcecreamHover2".emitting = s

func toggle_ice_stream(s = true):
	$"../CharacterSpringbox".toggle_ice_stream(s)

func is_on_ground():
	return floorCast.is_colliding()




func _on_body_entered(body):
	$sfx_bump.play_random()
	pass # Replace with function body.
