extends RigidBody3D

@export var entity_type:String

@export var hp = 25.0
signal entity_died

func _ready():
	if has_node("/root/ComboManager") != null:
		self.connect("entity_died",$"/root/ComboManager".on_combat_event)

func take_damage(dmg, dir):
	hp -= dmg
	$EntityHPBar.update_percent(hp)
	if hp <= 0.0:
		entity_died.emit("died_"+entity_type)
		queue_free()
	apply_force(dir * mass * dmg * 50 )


