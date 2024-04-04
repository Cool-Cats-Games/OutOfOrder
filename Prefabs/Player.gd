extends RigidBody3D


@export var acceleration = 200
@export var jumpSpeed = -300
@export var rideHeight = 5.0
@export var rideSpringDamper = 0.5
@export var rideSpringStrength = 1.0
@export var maxAccelerationForce = 150
@export var maxSpeed = 8

var speed = 0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")



func _physics_process(delta):
	apply_force($FloorCast.target_position * get_spring_force())

func get_spring_force():
	var vel = linear_velocity
	var raydir = $FloorCast.target_position
	var othervel = Vector3.ZERO
	if $FloorCast.is_colliding():
		var col = $FloorCast.get_collider()
		if "constant_linear_velocity" in col:
			othervel = col.constant_linear_velocity
		elif "linear_velocity" in col:
			othervel = col.linear_velocity
		elif "velocity" in col:
			othervel = col.velocity
	var rayDirVel = raydir.dot(vel)
	var otherDirVel = raydir.dot(othervel)
	var relvel = rayDirVel - otherDirVel
	var x = global_position.distance_to($FloorCast.get_collision_point()) - rideHeight
	var springforce = (x * rideSpringStrength) - (rayDirVel * rideSpringDamper)
	return springforce
