extends Node2D

var creamOn = load("res://Sprites/UI/iceCream.png")
var creamOff = load("res://Sprites/UI/iceCreamspent.png")

func set_top():
	$AnimationPlayer.play("Active")
	z_index = 2
	scale = Vector2(1.1,1.1)

func set_spent():
	$AnimationPlayer.stop()
	$IceCream.texture = creamOff
	scale = Vector2(0.9,0.9)
	z_index = 0

func set_on():
	$AnimationPlayer.stop()
	scale = Vector2(1.0,1.0)
	z_index = 1
	$IceCream.texture = creamOn
	
