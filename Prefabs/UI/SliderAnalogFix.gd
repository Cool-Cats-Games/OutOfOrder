extends HSlider

var isFocused : bool
var isSliding = 0


func _process(delta):
	if isSliding != 0 and isFocused:
		value += isSliding
	var ax = Input.get_axis("ui_left", "ui_right")
	isSliding = -step if ax < -0.4 else step if ax > 0.4 else 0

