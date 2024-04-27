extends Node2D

var speed = 0.0
var maxSpeed = 16.0
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
		speed = player.speed
	$SpeedometerNeedle.rotation = lerp($SpeedometerNeedle.rotation, deg_to_rad(lerp(-90,90, get_speed_percent())), 0.5)
	$Label.text = str(get_speed_percent() * 100).left(3) + ".0"
	pass

func get_speed_percent():
	return speed / maxSpeed
