extends CanvasLayer

var time = 0

func set_time(t):
	time = t
	$Label2.text = str(t)
	show()
	$Timer.start()


func _on_timer_timeout():
	time -= 1
	$Label2.text = str(time)
	if time < 0:
		hide()
	else:
		$Timer.start()
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name):
	$AnimatedSprite2D.rotation_degrees = 0
	$AnimatedSprite2D.frame = 0
	$AnimatedSprite2D.play("default")
	pass # Replace with function body.
