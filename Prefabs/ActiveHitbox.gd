extends Area3D

var hitEffectResource = load("res://Prefabs/Effects/HitEffect.tscn")

var damage_calculation = set_damage
@export var attackType:String

signal combat_event

func _ready():
	if has_node("/root/ComboManager") != null:
		self.connect("combat_event",$"/root/ComboManager".on_combat_event)

func _on_body_entered(body):
	body.take_damage(damage_calculation.call(body), get_parent().global_transform.basis.z)
	combat_event.emit(attackType) #Notify the ComboManager that a combo event occurred
	get_tree().call_group("MainCamera", "shake")
	var he = hitEffectResource.instantiate()
	get_parent().get_parent().add_child(he)
	he.position = global_position.lerp(body.global_position, 0.5)
	$"../sfx_hit_ram".play_random()


func velocity_damage(body):
	if not "linear_velocity" in body:
		return get_parent().linear_velocity
	return (get_parent().linear_velocity - body.linear_velocity).length()

func set_damage(body):
	return get_parent().get_damage()
