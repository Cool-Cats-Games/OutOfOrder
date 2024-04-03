extends Sprite2D

var idx = 0

func initialize(_idx, tex):
	idx = _idx
	if tex is String:
		tex = load(tex)
	texture = tex

func _process(delta):
	position.x = lerp(position.x, 0.0 + (75.0 * idx), 0.2)
