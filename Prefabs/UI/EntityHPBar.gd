extends Sprite3D

var percent = 1.0
var fadeOffset = 1.0

@onready var initialPos = position

@export var fadeCurve : Curve

func _ready():
	fadeOffset = 1.0
	$Fill.modulate = Color(1,1,1,0.0)

func _process(_delta):
	$Fill.modulate = Color(1,1,1,1)
	#$Fill.scale.x = lerp($Fill.scale.x, percent, 0.1)
	global_position = get_parent().global_position + initialPos
	var pxI = int(64 * percent)
	$Fill.region_rect.size.x = pxI
	$Fill.offset.x = lerp(-32.0, 0.0, percent)
	modulate.a = fadeCurve.sample(fadeOffset)
	fadeOffset = lerp(fadeOffset, 1.0, 0.01)

func update_percent(hp, maxHP):
	percent = hp / maxHP
	fadeOffset = 0.0
	#modulate = Color(1,1,1,1)
	
