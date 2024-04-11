extends Area3D




func _on_body_entered(body):
	body.take_damage((get_parent().linear_velocity - body.linear_velocity).length(), get_parent().global_transform.basis.z)
	get_tree().call_group("MainCamera", "shake")
	pass # Replace with function body.
