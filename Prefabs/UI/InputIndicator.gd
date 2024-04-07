extends Sprite2D

@export var action : String


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed(action):
		modulate.a = 1.0
	else:
		modulate.a = 0.1
	pass
