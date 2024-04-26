extends Area3D

var hitEffectResource = load("res://Prefabs/Effects/HitEffect.tscn")

var damage_calculation = set_damage

func _on_body_entered(body):
	body.take_damage(damage_calculation.call(body), get_parent().global_transform.basis.z, self)
	if not body.get_collision_layer_value(8):
		get_tree().call_group("MainCamera", "shake")
		var he = hitEffectResource.instantiate()
		get_parent().get_parent().add_child(he)
		he.position = global_position.lerp(body.global_position, 0.5)
		$"../sfx_hit_ram".play_random()
	pass # Replace with function body.

func velocity_damage(body):
	if not "linear_velocity" in body:
		return get_parent().linear_velocity
	return (get_parent().linear_velocity - body.linear_velocity).length()

func set_damage(body):
	return get_parent().get_damage()
