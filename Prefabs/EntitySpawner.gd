extends Node3D

signal on_entity_spawned

@export var radius = 0.0
@export var entityPath : String
@export var spawnLoop = false
@export var spawnOnReady = false
@export var spawnTimer = 0.0
@export var timerOnReady = false


var res

func _ready():
	res = load(entityPath)
	if spawnTimer > 0.0:
		$Timer.wait_time = spawnTimer
	if timerOnReady:
		$Timer.start(spawnTimer)

func start_spawn_timer():
	$Timer.start(spawnTimer)

func spawn():
	var eobj = res.instantiate()
	Utils.get_world(get_tree()).add_child(eobj)
	eobj.position = global_position + (Vector3(randf_range(-radius, radius),0.0,randf_range(-radius, radius)))
	if eobj is RigidBody3D:
		eobj.linear_velocity *= 0.0
	if spawnLoop and spawnTimer > 0.0:
		start_spawn_timer()
