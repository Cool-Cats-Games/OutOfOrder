extends RigidBody3D
signal on_death

@export var entity_type:String
var maxHP
@export var hp = 25.0
signal entity_died

func _ready():
	print("Entity ready")
	maxHP = hp
	$EntityHPBar.fadeOffset = 1.0
	if has_node("/root/ComboManager") != null:
		self.connect("entity_died",$"/root/ComboManager".on_combat_event)

func take_damage(dmg, dir, hitbox):
	hp -= dmg
	$EntityHPBar.update_percent(hp, maxHP)
	if hp <= 0.0:
		entity_died.emit("died_"+entity_type)
		on_death.emit()
		queue_free()
	apply_force(dir * mass * dmg * 50 )


