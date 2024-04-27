extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	gen_random()
	pass # Replace with function body.

func gen_random():
	var idx = randi_range(1,84)
	var s = "0" + str(idx) if idx < 10 else str(idx)
	texture = load("res://Textures/PixelPatterns/pattern_" + s + ".png")
	material.set_shader_parameter("colorMod", Color(randf_range(0.0,1.0),randf_range(0.0,1.0),randf_range(0.0,1.0),randf_range(0.5,1.0)))
	
