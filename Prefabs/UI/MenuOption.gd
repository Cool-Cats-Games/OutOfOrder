extends Node2D

signal on_selected(btn)
signal on_confirm()

@export var text = "Option"

var isValid = true
var isSelected = false

func _ready():
	set_text(text)

func deselect():
	$sprite.texture = load("res://Sprites/UI/bar_03.png")
	isSelected = false

func select():
	if isValid:
		isSelected = true
		$sfx_select.play()
		$AnimationPlayer.play("Select")
		$Delay.start()

func set_text(txt):
	$sprite/Label.text = txt

func _on_area_2d_body_entered(body):
	if not isSelected and isValid:
		select()
		body.velocity.y = 100
	pass # Replace with function body.


func _on_delay_timeout():
	on_selected.emit(self)
	pass # Replace with function body.


func _on_button_pressed():
	if not isSelected and isValid:
		select()
	elif  isSelected:
		on_confirm.emit()
	pass # Replace with function body.
