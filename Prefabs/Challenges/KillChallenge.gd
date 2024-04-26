extends "res://Prefabs/Challenges/Challenge.gd"


func _on_kill_counter_on_count_changed(count, goal):
	update_emblem({"count": count, "goal": goal})
	pass # Replace with function body.
