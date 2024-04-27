extends Area3D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var lifetimeMax = $"../IceStream".lifetime

var closest_body = null
var hitEffectRes = load("res://Prefabs/Effects/HitEffect.tscn")
var hitEffectSpawn = 0

func _physics_process(delta):
	if monitoring:
		if has_overlapping_bodies():
			var dist = 1000000.0
			if $"../CreamCast".is_colliding():
				closest_body = $"../CreamCast".get_collider()
				dist = $"../CreamCast".global_position.distance_to($"../CreamCast".get_collision_point())
				$CreamSplatters.global_position = $"../CreamCast".get_collision_point()
			else:
				for c in get_overlapping_bodies():
					if c.get_collision_layer_value(8):
						if c.has_method("take_damage"):
							c.take_damage(player.get_cream_damage(), player.global_transform.basis.z * 0.7, self)
						continue
					var dt = get_parent().global_position.distance_to(c.global_position)
					if dt < dist:
						dist = dt
						closest_body = c
				if not is_instance_valid(closest_body):
					closest_body = null
					$CreamSplatters.toggle(false)
					$"../IceStream".lifetime = lifetimeMax
					$"../IceStream2".lifetime = lifetimeMax
					return
				if closest_body.has_method("take_damage"):
					closest_body.take_damage(player.get_cream_damage(), player.global_transform.basis.z * 0.7, self)
				$CreamSplatters.global_position = closest_body.global_position
			$CreamSplatters.global_transform = $CreamSplatters.global_transform.looking_at(player.global_position)
			$CreamSplatters.global_position -= $CreamSplatters.global_transform.basis.z
			var xio = (dist - 1.87) / (10.54 - 1.87)
			$"../IceStream".lifetime = lerp(0.0,lifetimeMax, xio)
			$"../IceStream2".lifetime = lerp(0.0,lifetimeMax, xio)
			$CreamSplatters.toggle(true)
			if hitEffectSpawn % 4 == 0:
				var hef = hitEffectRes.instantiate()
				get_parent().get_parent().add_child(hef)
				hef.position = $CreamSplatters.global_position + Vector3(randf_range(-1.0,1.0),randf_range(-1.0,1.0),randf_range(-1.0,1.0))
			hitEffectSpawn += 1
		else:
			closest_body = null
			$CreamSplatters.toggle(false)
			$"../IceStream".lifetime = lifetimeMax
			$"../IceStream2".lifetime = lifetimeMax
