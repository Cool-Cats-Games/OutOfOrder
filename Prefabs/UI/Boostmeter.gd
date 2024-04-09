extends Node2D

@onready var player = get_tree().get_first_node_in_group("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var boostPerc = lerp(0.8,0.5, (player.boost / player.boostMax))
	$Meter.material.set_shader_parameter("fill_ratio", boostPerc)
	pass
