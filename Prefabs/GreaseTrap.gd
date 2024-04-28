extends Node3D

var nextTrap = 0

func get_grease_trap():
	match nextTrap:
		0:
			return $GreaseLauncher
		1:
			return $GreaseLauncher2
		2:
			return $GreaseLauncher3


func _on_timer_timeout():
	get_grease_trap().launch()
	nextTrap = wrapi(nextTrap + 1, 0,3)
	$Timer.start(randf_range(1.0,5.0))
	$sfx_splatter.play()
	pass # Replace with function body.
