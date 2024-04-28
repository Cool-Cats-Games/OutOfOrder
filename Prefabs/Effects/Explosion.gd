extends "res://Prefabs/Effects/GenericParticleEffect.gd"

var smallFireRes = preload("res://Prefabs/Effects/LittleIgnitable.tscn")

func fire(at = position, _msg = {}):
	get_tree().call_group("MainCamera", "camera_shake")
	$ExplosionShrapnel.emitting=true
	msg = _msg
	position = at
	emit_signal("on_fire")
	var i = randi_range(4,8)
	for idx in range(i):
		var obj = smallFireRes.instantiate()
		var house = get_tree().get_nodes_in_group("House")[0]
		house.add_child(obj)
		obj.position = global_position
		obj.velocity = Vector2(randf_range(-1.0,1.0),randf_range(-1.0,1.0)) * randf_range(60.0,110.0)
