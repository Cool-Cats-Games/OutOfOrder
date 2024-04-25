extends State

var pointOfAlert = Vector3()

func enter(_msg := {}) -> void:
	super.enter(_msg)
	pointOfAlert = _msg["from"]
	var ac = actor.get_animation_controller()
	ac.animation_finished.connect(on_alert_done)
	ac.play("Scared")
	pass

func exit():
	super.exit()
	var ac = actor.get_animation_controller()
	ac.animation_finished.disconnect(on_alert_done)

func on_alert_done(anim_name):
	state_machine.transition_to("Flee", {"from": pointOfAlert})