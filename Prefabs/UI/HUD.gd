extends CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		Utils.get_world(get_tree()).add_child(load("res://Prefabs/UI/PauseMenu.tscn").instantiate())

func clear_health_bar():
	for c in $HealthGauge.get_children():
		c.queue_free()
		$HealthGauge.remove_child(c)

func update_health(hp):
	var idx = 1
	for c in $HealthGauge.get_children():
		if idx < hp:
			c.set_on()
		elif idx == hp:
			c.set_top()
		else:
			c.set_spent()
		idx += 1

func update_max_health(maxHP):
	var hpBarRef = load("res://Prefabs/UI/HUD_HPBar.tscn")
	clear_health_bar()
	for i in range(maxHP):
		var hpbar = hpBarRef.instantiate()
		$HealthGauge.add_child(hpbar)
		hpbar.position.y += (maxHP - i) * 40
		
