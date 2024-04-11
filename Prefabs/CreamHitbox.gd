extends Area3D

@onready var player = get_tree().get_first_node_in_group("Player")

var closest_body = null

func _process(delta):
	if has_overlapping_bodies():
		var dist = 1000000.0
		for c in get_overlapping_bodies():
			var dt = get_parent().global_position.distance_to(c.global_position)
			if dt < dist:
				dist = dt
				closest_body = c
		closest_body.take_damage(player.get_cream_damage(), player.global_transform.basis.z * 2.0)
		var xio = (dist - 1.87) / (10.54 - 1.87)
		$"../IceStream".lifetime = lerp(0.0,1.2, xio)
		$"../IceStream2".lifetime = lerp(0.0,1.2, xio)
	else:
		$"../IceStream".lifetime = 1.2
		$"../IceStream2".lifetime = 1.2
