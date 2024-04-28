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
var damage = 10.0
var enableIntegrateForces = true
var canBoost = true
var characterModel = null
var cream = 100.0
var creamDepleted = false
var creamMax = 100.0
var creamRegen = 0.5
var creamHitPenalty = 75
var facingPoint = Vector3.ZERO
var hp = 4
var hpMax = 4
var localInputVector = Vector3()
var mainCamera = null
var rideSpringScaler = 1.0
var rotAng = 0.0
var speed = 0.0
var specialAvaliable = false
var ticks = 0

var isOffGround = false


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	get_main_camera()
	get_tree().call_group("HUD", "show")
	get_tree().call_group("HUD", "update_max_health", hpMax)
	get_tree().call_group("HUD", "update_health", hp)
	initialize_location.call_deferred()

func _process(_delta):
	if (canBoost and not Input.is_action_pressed("boost")) or not canBoost:
		boost = clamp(boost + boostRegen, 0.0, boostMax)
		if boost == boostMax:
			canBoost = true
	var is_at_cream = cream == creamMax
	if cream <= 0.0:
		creamDepleted = true
		#emit signal for whatever when run out of cream
	cream = clamp(cream + (creamRegen if not creamDepleted else 0.0), 0.0, creamMax)
	if not is_at_cream and cream == creamMax:
		$sfx_creamReady.play()
	if isOffGround and $Landed.is_colliding() and $StateMachine.get_state_name() != "Hover":
		isOffGround = false
		var lefx = load("res://Prefabs/Effects/landing_smoke.tscn").instantiate()
		Utils.get_world(get_tree()).add_child(lefx)
		lefx.position = $Landed.get_collision_point() + Vector3(0,0.1,0)
		$sfx_land.play_random()
	pass

func _integrate_forces(_state):
	floorCast.rotation = rotation * -1
	if enableIntegrateForces:
		apply_force(floorCast.target_position * get_spring_force())
	var unitInput = localInputVector.normalized()
	var goalVel = unitInput * maxSpeed
	var stepVel = linear_velocity.lerp(goalVel, acceleration)
	if enableIntegrateForces:
		apply_force(stepVel * mass)
	speed = abs(Vector3(linear_velocity.x, 0.0, linear_velocity.z).length())

func combo_ended():
	$sfx_special_ready.stop()
	specialAvaliable = false

func get_character_model():
	return characterModel

func get_cream_damage():
	return 1.0

func get_ice_cream_fv():
	return cream / creamMax

func get_damage():
	return damage

func get_desired_movement():
	return localInputVector

func get_HUD():
	return get_tree().get_first_node_in_group("HUD")

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
	var x = global_position.distance_to(floorCast.get_collision_point() if floorCast.is_colliding() else get_node("LongCast").get_collision_point()) - rideHeight
	var springforce = (x * rideSpringStrength) - (rayDirVel * rideSpringDamper)
	if floorCast.is_colliding():
		var body = floorCast.get_collider()
		if body == null:
			pass
		elif body.has_method("apply_force"):
			body.apply_force(-1.0 * floorCast.target_position * springforce)
	return springforce * rideSpringScaler

func on_special_threshold():
	specialAvaliable = true
	$sfx_special_ready.play()

func initialize_location():
	var targetPointName = GameDataManager.gameData.doorName
	var d = Utils.get_world(get_tree()).get_node(NodePath(targetPointName))
	if is_instance_valid(d):
		position = d.global_position
		if d.has_method("get_facing_dir"):
			var p = global_position - d.get_facing_dir() * 30
			p.y = global_position.y
			look_at(p)
			var mt = mainCamera.transform
			mainCamera.quaternion = Quaternion(Transform3D.IDENTITY.looking_at(global_position + d.get_facing_dir(), Vector3.UP).basis)
			mainCamera.rotation.x = 0
			mainCamera.rotation.z = 0

func play_sound(stream):
	$sfx_player_generic.stream = stream
	$sfx_player_generic.play()

func take_damage(dir):
	#apply_force(Vector3.UP * 450 + dir * 250)
	apply_central_impulse(Vector3.UP * 4 + dir * 2.5)
	get_character_model().play_animation("damage")
	if not creamDepleted:
		cream = clamp(cream - creamHitPenalty, 0.0, creamMax)
		$sfx_hurt_cream_squelch.play_random()
		if cream == 0.0:
			creamDepleted = true
	else:
		hp -= 1
		$sfx_hurt.play_random()
		$DamageTimer.start()
		get_tree().call_group("HUD", "update_health", hp)
		if hp <= 0:
			var dfx = load("res://Prefabs/Effects/DeathParticles.tscn").instantiate()
			Utils.get_world(get_tree()).add_child(dfx)
			dfx.position = position
			queue_free()
			get_character_model().queue_free()
			get_tree().call_group("HUD", "hide")
			print("Game Over")
	

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


func _on_damage_timer_timeout():
	get_character_model().play_animation("damage_exit")
	pass # Replace with function body.
