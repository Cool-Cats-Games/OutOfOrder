extends Node2D

var entityRef
var rank = 1

func _process(delta):
	position.y = lerp(position.y, 64.0 * (rank - 1), 0.4)
	if entityRef != null:
		if entityRef.get_state_name() == "Dead":
			toggle_dead_view()
		else:
			hide_dead_view()

func hide_dead_view():
	$GooberIcon2.show()
	$Dead.hide()

func initialize(entity, _rank):
	entityRef = entity
	set_display_color(entity.modulate)
	set_display_name(entity.name)
	rank = _rank
	var mat = entity.get_animation_controller().material
	set_sprite_skin(mat)

func update_points(points):
	$Score.text = str(points)

func set_display_color(_color):
	$Scorebar2.modulate = _color

func set_display_name(_name):
	$Name.text = _name

func set_sprite_skin(tex, colormod = Color(1.0,1.0,1.0,1.0)):
	if tex is Material:
		$GooberIcon2.material = tex
		return
	elif tex is String:
		tex = load("res://Sprites/Skins/" + tex + ".png")
	$GooberIcon2.material.set_shader_parameter("map", tex)
	$GooberIcon2.material.set_shader_parameter("colormod", colormod)

func toggle_dead_view():
	$GooberIcon2.hide()
	$Dead.show()
	pass


