class_name EntitySpawner
extends Resource

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

