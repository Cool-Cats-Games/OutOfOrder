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

func test_exit(target_state_name) -> bool:
	return target_state_name != "Alert"

func test(target_state_name):
	return target_state_name != name
