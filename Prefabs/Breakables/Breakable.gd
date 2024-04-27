extends RigidBody3D

@export var hp = 1.0
@export var squibs : Array[Resource]
@export var breaksfx : Array[AudioStream]

var entity_type = "breakable"
signal entity_died

func _ready():
	if has_node("/root/ComboManager") != null:
		self.connect("entity_died",$"/root/ComboManager".on_combat_event)

func smash():
  entity_died.emit("died_"+entity_type)
	queue_free()
	Utils.play_sound_at(breaksfx, get_tree(), global_position, -3.0)
	if squibs.size() > 0:
		for s in range(randi_range(2,6)):
			spawn_random_squib()

func spawn_random_squib():
	var slr = squibs.pick_random().instantiate()
	get_parent().add_child(slr)
	slr.position = position
	slr.apply_force(Vector3(randf_range(-1.0,1.0) * 50, randf_range(10,50) * 5, randf_range(-1.0,1.0) * 50))
	slr.apply_torque(Vector3(randf_range(-1.0,1.0) * 5, randf_range(-1.0,1.0), randf_range(-1.0,1.0) * 5))
	slr.get_node("TTL").start(randf_range(0.5,5.0))

func take_damage(dmg, dir, hitbox):
	hp -= dmg
	apply_force(dir * mass * dmg)
	if hp <= 0.0:
		smash()