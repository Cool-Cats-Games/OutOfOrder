extends State

func enter(_msg := {}) -> void:
	super.enter(_msg)
	var ac = actor.get_animation_controller()
	ac.play("Attack")
	ac.animation_finished.connect(on_attack_ended)

func on_attack_ended(anim_name):
	if is_instance_valid(actor.target):
		actor.aggro(actor.target)
	else:
		state_machine.transition_to("Idle")
	pass

func exit():
	super.exit()
	var ac = actor.get_animation_controller()
	ac.animation_finished.disconnect(on_attack_ended)
