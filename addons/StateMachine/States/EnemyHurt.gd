extends State


func enter(_msg := {}) -> void:
	super.enter(_msg)
	var ac = actor.get_animation_controller()
	ac.play("Hurt")
	ac.animation_finished.connect(hurt_timeout)

func hurt_timeout(anim_name):
	state_machine.transition_to("Idle")

func exit():
	super.exit()
	var ac = actor.get_animation_controller()
	ac.animation_finished.disconnect(hurt_timeout)

func test_exit(target_state_name):
	return not $"../../TommyTwoTraps/AnimationPlayer".is_playing()
