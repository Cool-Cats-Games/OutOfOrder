extends Button

signal on_select(sli)

var isHovered = false
var isSelected = false
var modeName = "Mode"

func deselect():
	$Bar02.modulate = Color("7ca2f2")
	isHovered = false
	isSelected = false
	$checked.hide()
	$Label.set("theme_override_colors/font_color", Color.BLACK)

func hover():
	if not isHovered and not isSelected:
		isHovered = true
		$sfx_hover.play()
		$Label.set("theme_override_colors/font_color", Color.WHITE)

func initialize(_modeName):
	modeName = _modeName
	$Label.text = modeName

func unhover():
	if isHovered:
		$Label.set("theme_override_colors/font_color", Color.BLACK)
		isHovered = false
	pass # Replace with function body.

func select():
	isSelected = true
	#$AnimationPlayer.play("Select")
	$Bar02.modulate = Color("e48a51")
	$checked.show()
	$sfx_select.play()
	on_select.emit(self)


func _on_pressed():
	if isSelected:
		deselect()
	else:
		select()
	pass # Replace with function body.
