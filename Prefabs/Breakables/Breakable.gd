extends RigidBody3D

@export var hp = 1.0
@export var squibs : Array[Resource]
@export var breaksfx : Array[AudioStream]

var entity_type = "breakable"
signal entity_died

func _ready():
	if has_node("/root/ComboManager") != null:
		self.connect("entity_died",$"/root/ComboManager".on_combat_event)

func take_damage(dmg, dir):
	hp -= dmg
	apply_force(dir * mass * dmg)
	if hp <= 0.0:
		queue_free()
		entity_died.emit("died_"+entity_type)
		Utils.play_sound_at(breaksfx, get_tree(), global_position, -3.0)
		for s in range(randi_range(2,6)):
			var slr = squibs.pick_random().instantiate()
			get_parent().add_child(slr)
			slr.position = position
			slr.apply_force(Vector3(randf_range(-1.0,1.0) * 50, randf_range(10,50) * 5, randf_range(-1.0,1.0) * 50))
			slr.get_node("TTL").start(randf_range(0.5,5.0))
