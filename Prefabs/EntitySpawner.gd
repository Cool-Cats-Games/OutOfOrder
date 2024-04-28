extends Node3D

signal on_entity_spawned(entity)

@export var enabled = true
@export var radius = 0.0
@export var entityPath : String
@export var spawnForce = Vector3()
@export var spawnLoop = false
@export var spawnOnReady = false
@export var spawnTimer = 0.0
@export var timerOnReady = false
@export var spawnLimit = 0 #How many can be active at a time, 0 = infinite

@export var requires_floor = true #Whether it checks to spawn on floor
#@export var dont_spawn_in_vision = false #Whether it checks to spawn outside player vision

var spawned = []

var res

func _ready():
	initialize()

func configure(esr : EntitySpawner):
	enabled = esr.enabled
	radius = esr.radius
	entityPath = esr.entityPath
	spawnForce = esr.spawnForce
	spawnLoop = esr.spawnLoop
	spawnOnReady = esr.spawnOnReady
	spawnTimer = esr.spawnTimer
	timerOnReady = esr.timerOnReady
	spawnLimit = esr.spawnLimit
	requires_floor = esr.requires_floor
	initialize()

func initialize():
	res = load(entityPath)
	if spawnTimer > 0.0:
		$Timer.wait_time = spawnTimer
	if timerOnReady:
		$Timer.start(spawnTimer)

func start_spawn_timer():
	$Timer.start(spawnTimer)

func spawn():
	if enabled:
		if spawnLimit == 0 or spawned.size() < spawnLimit:
			var tries = 100 #How many times to try and spawn
			var eobj = res.instantiate()
			Utils.get_world(get_tree()).add_child(eobj)
			var spawnPosition = global_position + (Vector3(randf_range(-radius, radius),0.0,randf_range(-radius, radius)))
			while not check_floor(spawnPosition) and tries > 0:
				tries -= 1
				spawnPosition = global_position + (Vector3(randf_range(-radius, radius),0.0,randf_range(-radius, radius)))
			if tries == 0:
				print("Failed to spawn entity, no floor found")
			else:
				eobj.position = spawnPosition
				if eobj is RigidBody3D:
					eobj.linear_velocity *= 0.0
					eobj.apply_impulse(spawnForce)
				on_entity_spawned.emit(eobj)
				spawned.append(eobj)
				eobj.connect("entity_died",self.on_spawned_entity_died)
	if spawnLoop and spawnTimer > 0.0:
		start_spawn_timer()

func on_spawned_entity_died(entity):
	if entity in spawned:
		entity.disconnect("entity_died",self.on_spawned_entity_died)
		spawned.erase(entity)

func check_floor(pos):
	if requires_floor == false: return true #If the floor isn't needed, it's always true
	var space_state = get_world_3d().direct_space_state
	var origin = pos + Vector3(0,-10,0)
	var end = pos + Vector3(0,10,0)
	var query = PhysicsRayQueryParameters3D.create(origin,end)
	var result = space_state.intersect_ray(query)
	if result: return true
	return false

func delete():
	queue_free()
	get_tree().call_group("World", "register_instance_deleted", get_path())
