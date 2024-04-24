extends "res://Prefabs/SimpleEnemy.gd"

@export var squibs : Array[Resource]
@export var breaksfx : Array[AudioStream]

func take_damage(dmg, dir, hitbox):
	hp -= dmg
	apply_force(dir * mass * dmg)
	if hp <= 0.0:
		queue_free()
		Utils.play_sound_at(breaksfx, get_tree(), global_position, -3.0)
		for s in range(randi_range(2,6)):
			var slr = squibs.pick_random().instantiate()
			get_parent().add_child(slr)
			slr.position = position
			slr.apply_force(Vector3(randf_range(-1.0,1.0) * 50, randf_range(10,50) * 5, randf_range(-1.0,1.0) * 50))
			slr.get_node("TTL").start(randf_range(0.5,5.0))
		pass
