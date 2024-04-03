extends Button

signal on_select(sli)
signal on_hover(sli)
signal on_hover_exit(sli)

var isHovered = false
var isSelected = false
var skin = "Default"
var skinIDX = 0

func deselect():
	$Bar02.modulate = Color("7ca2f2")
	isHovered = false
	isSelected = false
	$Label.set("theme_override_colors/font_color", Color.BLACK)

func hover():
	if not isHovered and not isSelected:
		call_deferred("emit_signal", "on_hover", self)
		isHovered = true
		$sfx_hover.play()
		$Label.set("theme_override_colors/font_color", Color.WHITE)

func initialize(_skin, idx):
	skinIDX = idx
	skin = _skin
	$Label.text = skin

func unhover():
	if isHovered:
		on_hover_exit.emit(self)
		$Label.set("theme_override_colors/font_color", Color.BLACK)
		isHovered = false
	pass # Replace with function body.

func select():
	isSelected = true
	$AnimationPlayer.play("Select")
	$sfx_select.play()
	on_select.emit(self)
