extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("Player")


func _process(_delta):
	material.set_shader_parameter("fV", lerp(0.1,0.9,player.get_ice_cream_fv()))
