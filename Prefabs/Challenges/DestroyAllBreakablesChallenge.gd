extends "res://Prefabs/Challenges/Challenge.gd"

func start_challenge():
	super.start_challenge()
	var breakables = get_tree().get_nodes_in_group("Breakables")
	if breakables.size() == 0:
		update_emblem({"count": 0, "goal": 0})
		complete()
		return
	$KillCounter.goal = breakables.size()
	$KillCounter.count = 0
	update_emblem({"count": $KillCounter.count, "goal": $KillCounter.goal})
	#AudioManager.play_playist("Battlefight", "B")


func _on_kill_counter_on_count_changed(count, goal):
	update_emblem({"count": count, "goal": goal})
	pass # Replace with function body.
