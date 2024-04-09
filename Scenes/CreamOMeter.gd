extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("Player")


func _process(_delta):
	material.set_shader_parameter("fV", player.get_ice_cream_fv())
