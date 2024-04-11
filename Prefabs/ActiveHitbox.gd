extends Area3D




func _on_body_entered(body):
	body.take_damage(get_parent())
	get_tree().call_group("MainCamera", "shake")
	pass # Replace with function body.
