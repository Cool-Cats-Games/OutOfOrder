extends "res://Prefabs/Breakables/Destroyable.gd"

@export var screens : Array[Texture]




func _on_timer_timeout():
	$SelfHelpKiosk/Screen2.material_override.albedo_texture = screens.pick_random()
	pass # Replace with function body.
