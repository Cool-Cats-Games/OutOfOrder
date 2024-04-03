extends CanvasLayer

signal on_clear()

var canClear = false


func _process(delta):
	if canClear:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
			$UIAnimations.play("Out")

func initialize(typetext, badgetxt):
	$Box1/Label.text = badgetxt
	$Box1/Type/RichTextLabel.text = "[wave]NEW " + typetext + "!"


func _on_ui_animations_animation_finished(anim_name):
	match anim_name:
		"default":
			canClear = true
		"Out":
			on_clear.emit()
	pass # Replace with function body.
