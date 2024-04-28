extends "res://Prefabs/Challenges/KillChallenge.gd"

@export var spawnerRes : Resource
@export var useResource = true

var spawner

func _ready():
	super._ready()
	spawner = $EntitySpawner
	if useResource:
		spawner.configure(spawnerRes)
