extends State


func enter(_msg := {}) -> void:
	super.enter(_msg)
	var ac = actor.get_animation_controller()
	ac.play("Launch")
	ac.animation_finished.connect(launch_finished)

func launch_finished(anim_name):
	state_machine.transition_to("Idle")

func exit():
	super.exit()
	var ac = actor.get_animation_controller()
	ac.animation_finished.disconnect(launch_finished)
