extends "res://Prefabs/Entity.gd"

@onready var floorCast = $RayCast3D
@onready var uprightQuat = quaternion

@export var acceleration = 5.0
@export var jumpSpeed = 700
@export var rideHeight = 1.3
@export var rideSpringDamper = 0.6
@export var rideSpringStrength = 30.0
@export var maxAccelerationForce = 150
@export var maxSpeed = 2.5
@export var uprightSpringStrength = 30.0
@export var uprightSpringDampener = 4.0


var enableForceIntegration = true
var enableCorrectiveForce = true
var facingPoint = Vector3.ZERO
var isPatrolling = false
var localInputVector = Vector3()
var rideSpringScaler = 1.0
var rotAng = 0.0
var speed = 0.0
var target = null

func _integrate_forces(state):
	floorCast.rotation = rotation * -1
	if enableForceIntegration:
		apply_force(floorCast.target_position * get_spring_force())
	var unitInput = localInputVector.normalized()
	var goalVel = unitInput * maxSpeed
	var stepVel = linear_velocity.lerp(goalVel, acceleration)
	if enableForceIntegration:
		apply_force(stepVel * mass)
	speed = abs(Vector3(linear_velocity.x, 0.0, linear_velocity.z).length())
	if enableForceIntegration and enableCorrectiveForce:
		correct_upright_force()

func correct_upright_force():
	var charCurrentRotation = quaternion
	var goalQuaternion = Utils.ShortestRotation(uprightQuat, charCurrentRotation)
	var rotAngle = goalQuaternion.get_angle()
	var rotAxis = goalQuaternion.get_axis().normalized()
	apply_torque((rotAxis * (rotAngle * uprightSpringStrength)) - (angular_velocity * uprightSpringDampener))

func get_animation_controller():
	#override with specific
	pass

func get_spring_force():
	var vel = linear_velocity
	var raydir = floorCast.target_position
	var othervel = Vector3.ZERO
	if floorCast.is_colliding():
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
	return springforce * rideSpringScaler

func get_state_machine():
	return $StateMachine

func get_state_name():
	return get_state_machine().get_state_name()

func aggro(body):
	target = body
	set_state("Chase")
	pass # Replace with function body.


func aggro_exit(body):
	if body == target and get_state_name() in ["Chase"]:
		target = null
		set_state("Idle")
	pass # Replace with function body.


func set_state(stateName, _msg = {}):
	get_state_machine().transition_to(stateName, _msg)

func take_damage(dmg, dir, hitbox):
	super.take_damage(dmg, dir, hitbox)
	if hp <= 0:
		get_tree().call_group("EnemyDeathSubscribers", "on_enemy_death", self)
	set_state("Hurt", {"dmg":dmg, "dir":dir, "hitbox":hitbox})

func walk_to(point):
	set_state("WalkTo", {"points": [point]})

func follow_path(points):
	set_state("WalkTo", {"points": points})
