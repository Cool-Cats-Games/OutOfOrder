@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("StateMachine", "Node", preload("StateMachine.gd"), preload("res://Sprites/UI/Kenny_input_prompts_pixel/Tiles (White)/tile_0000.png"))
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("StateMachine")
	pass
