extends Area3D

var hitEffectResource = load("res://Prefabs/Effects/HitEffect.tscn")

func _on_body_entered(body):
	body.take_damage((get_parent().linear_velocity - body.linear_velocity).length(), get_parent().global_transform.basis.z)
	get_tree().call_group("MainCamera", "shake")
	var he = hitEffectResource.instantiate()
	get_parent().get_parent().add_child(he)
	he.position = global_position.lerp(body.global_position, 0.5)
	$"../sfx_hit_ram".play_random()
	pass # Replace with function body.
