@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("GenericEvent", "Node3D", preload("GenericEvent.gd"), preload("res://Sprites/UI/Kenny_input_prompts_pixel/Tiles (White)/tile_0000.png"))
	add_custom_type("ABSwitchEvent", "Node3D", preload("ABSwitchEvent.gd"), preload("res://Sprites/UI/Kenny_input_prompts_pixel/Tiles (White)/tile_0000.png"))
	add_custom_type("TimerEvent", "Node3D", preload("TimerEvent.gd"), preload("res://Sprites/UI/Kenny_input_prompts_pixel/Tiles (White)/tile_0000.png"))
	add_custom_type("CounterEvent", "Node3D", preload("CounterEvent.gd"), preload("res://Sprites/UI/Kenny_input_prompts_pixel/Tiles (White)/tile_0000.png"))
	
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("GenericEvent")
	remove_custom_type("ABSwitchEvent")
	remove_custom_type("TimerEvent")
	remove_custom_type("CounterEvent")
	pass
