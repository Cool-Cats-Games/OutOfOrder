extends State

@onready var hitbox = $"../../LightAtkHitbox"

var attackState = 0


func enter(_msg := {}) -> void:
	super.enter(_msg)
	var s = str(1 + attackState)
	hitbox.damage_calculation = hitbox.set_damage
	$"../../AnimationPlayer".play("LightAttack" + s)
	$"../../AnimationPlayer".animation_finished.connect(attack_finished)
	actor.get_character_model().apply_torque(Vector3(0,-100 if attackState == 0 else 100,00))
	attackState = 1 if attackState == 0 else 0
	

func attack_finished(anim_name):
	state_machine.transition_to("Idle")

func exit():
	super.exit()
	$"../../AnimationPlayer".animation_finished.disconnect(attack_finished)
	$"../../FistRig/Fist".modulate.a = 0.0
	hitbox.monitoring = false
