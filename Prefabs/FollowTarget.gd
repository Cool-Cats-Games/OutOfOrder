extends Node3D

@onready var target = get_tree().get_first_node_in_group("Player")

func _physics_process(delta):
	position = target.position
	#rotation.y = target.rotation.y
