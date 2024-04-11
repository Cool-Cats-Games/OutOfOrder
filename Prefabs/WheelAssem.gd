extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_rotation.y = $"../../CharacterSpringbox".global_rotation.y
	if $"../FloorCast".is_colliding():
		#global_position.y = lerp(global_position.y, $"../FloorCast".get_collision_point().y + 0.1, 0.1)
		if $"../StateMachine".get_state_name() == "Hover":
			global_position.y = lerp(global_position.y, $"..".global_position.y - 1.0, 0.1)
		else:
			global_position.y = $"../FloorCast".get_collision_point().y + 0.1
		for c in $WheelContainer.get_children():
			c.rotation.z += $"..".speed / 5.0
	else:
		global_position.y = lerp(global_position.y, $"..".global_position.y - 1.0, 0.1)
	pass
