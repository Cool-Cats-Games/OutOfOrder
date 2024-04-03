extends Button

func highlight():
	if $AnimationPlayer.current_animation != "focused":
		$AnimationPlayer.play("focused")
		$sfx_focus.play()

func unhighlight():
	$AnimationPlayer.play("default")
	$sfx_unfocus.play()

