extends Node3D

var projectileRef = load("res://Prefabs/GreaseProjectile.tscn")
var launchDir = Vector3()

func _ready():
	$launchPoint.hide()

func launch():
	var gp = projectileRef.instantiate()
	Utils.get_world(get_tree()).add_child(gp)
	gp.position = global_position
	launchDir = global_position.direction_to($launchPoint.global_position)
	gp.launch(launchDir, launchDir, 1.5,0.5)
