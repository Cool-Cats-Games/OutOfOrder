extends "res://Prefabs/Challenges/Challenge.gd"

func start_challenge():
	super.start_challenge()
	update_emblem({"count": $KillCounter.count, "goal": $KillCounter.goal})
	AudioManager.play_playist("Battlefight", "B")

func _on_kill_counter_on_count_changed(count, goal):
	update_emblem({"count": count, "goal": goal})
	pass # Replace with function body.


func _on_on_challenge_complete():
	AudioManager.switch_part("A")
	pass # Replace with function body.
