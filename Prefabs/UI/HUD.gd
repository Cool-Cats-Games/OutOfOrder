extends CanvasLayer


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
	for i in range(maxHP):
		var hpbar = hpBarRef.instantiate()
		$HealthGauge.add_child(hpbar)
		hpbar.position.y += (maxHP - i) * 40
		
