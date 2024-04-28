extends State

func enter(_msg := {}) -> void:
	super.enter(_msg)
	actor.enableCorrectiveForce = false
	actor.enableForceIntegration = false
	var ac = actor.get_animation_controller()
	ac.play("Ragdoll")
	$Timer.start(1.0 + actor.linear_velocity.length())
	actor.localInputVector = Vector3.ZERO
	actor.linear_velocity = Vector3.ZERO

func exit():
	super.exit()
	actor.enableCorrectiveForce = true
	actor.enableForceIntegration = true
	$"../../MeshContainer".rotation.y = 90


func _on_timer_timeout():
	var poa = $"../Alert".pointOfAlert
	state_machine.transition_to("Alert", {"from": poa})
	$"../../flee_panic_timer".start(randf_range(1.0,5.0))
	pass # Replace with function body.
