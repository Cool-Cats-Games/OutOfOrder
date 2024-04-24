extends Node3D

func _ready():
	$Hit.emitting = true



func _on_timer_timeout():
	#transition to game over
	get_tree().change_scene_to_file("res://Scenes/GameOver.tscn")
	pass # Replace with function body.
