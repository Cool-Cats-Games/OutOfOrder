extends Node3D

signal on_entity_spawned(entity)
signal resource_loaded()

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

@export var forceFloorHeight = false
@export var forcedFloorHeight = Vector3.ZERO

var hasInitialized = false
var res
var spawned = []


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
	resource_loaded.emit()
	hasInitialized = true
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
			if not hasInitialized:
				await self.resource_loaded
			var eobj = res.instantiate()
			Utils.get_world(get_tree()).add_child(eobj)
			var spawnPosition = global_position + (Vector3(randf_range(-radius, radius),0.0,randf_range(-radius, radius)))
			while not check_floor(spawnPosition) and tries > 0:
				tries -= 1
				spawnPosition = global_position + (Vector3(randf_range(-radius, radius),0.0,randf_range(-radius, radius)))
			if tries == 0:
				print("Failed to spawn entity, no floor found")
				if forcedFloorHeight:
					eobj.position.y = forcedFloorHeight.y
			else:
				eobj.position = spawnPosition
				if forcedFloorHeight:
					eobj.position.y = forcedFloorHeight.y
				if eobj is RigidBody3D:
					eobj.linear_velocity *= 0.0
					eobj.apply_impulse(spawnForce)
				on_entity_spawned.emit(eobj)
				spawned.append(eobj)
				eobj.connect("entity_died",self.on_spawned_entity_died.bind(eobj))
	if spawnLoop and spawnTimer > 0.0:
		start_spawn_timer()

func trigger(by = null):
	spawn()

func on_spawned_entity_died(entityDeathMessage, entity):
	if entity in spawned:
		entity.disconnect("entity_died",self.on_spawned_entity_died)
		spawned.erase(entity)

func check_floor(pos):
	if requires_floor == false: return true #If the floor isn't needed, it's always true
	var space_state = get_world_3d().direct_space_state
	var origin = pos + Vector3(0,-10,0)
	var end = pos + Vector3(0,10,0)
	var query = PhysicsRayQueryParameters3D.create(origin,end)
	query.hit_back_faces = true
	var result = space_state.intersect_ray(query)
	if result: return true
	return false

func delete():
	queue_free()
	get_tree().call_group("World", "register_instance_deleted", get_path())
