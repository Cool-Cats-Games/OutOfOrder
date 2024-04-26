extends Node3D

func toggle(s = true):
	$particles.emitting = s
	$Timer.start(0.3)


func _on_timer_timeout():
	toggle(false)
	pass # Replace with function body.
