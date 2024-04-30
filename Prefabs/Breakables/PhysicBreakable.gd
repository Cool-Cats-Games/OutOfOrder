extends "res://Prefabs/SimpleEnemy.gd"

@export var squibs : Array[Resource]
@export var breaksfx : Array[AudioStream]

func _ready():
	super._ready()
	add_to_group("Breakables")

func take_damage(dmg, dir, hitbox):
	hp -= dmg
	apply_force(dir * mass * dmg)
	if hp <= 0.0:
		queue_free()
		on_death.emit()
		entity_died.emit("died_"+entity_type)
		get_tree().call_group("BreakablesBrokenSubscriber", "on_breakable_smashed", self)
		Utils.play_sound_at(breaksfx, get_tree(), global_position, -3.0)
		if squibs.size() == 0:return
		for s in range(randi_range(2,6)):
			var slr = squibs.pick_random().instantiate()
			get_parent().add_child(slr)
			slr.position = position
			slr.apply_force(Vector3(randf_range(-1.0,1.0) * 50, randf_range(10,50) * 5, randf_range(-1.0,1.0) * 50))
			slr.get_node("TTL").start(randf_range(0.5,5.0))
	apply_force(dir * mass * dmg * 50 )
