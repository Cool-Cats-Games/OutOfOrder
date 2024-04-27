extends Node2D

var comboManager = null

func _ready():
	comboManager = $ComboManager
	comboManager.register_ui($ComboMeter)

func _input(event:InputEvent):
	if event is InputEventKey and event.is_pressed():
		print(event.key_label)
		if event.keycode == KEY_A:
			comboManager.add_instance("light_attack")
		elif event.keycode == KEY_B:
			comboManager.add_instance("heavy_attack")
