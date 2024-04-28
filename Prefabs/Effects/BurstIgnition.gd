extends Area2D
@export var heat : float = 250

var radius = 10
func _ready():
	$Radius.shape.radius = radius

func _on_body_entered(body):
	body.get_parent().add_heat(heat)
	pass # Replace with function body.
