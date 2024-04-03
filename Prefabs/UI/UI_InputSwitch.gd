extends Node2D


func _process(delta):
	if Settings.lastInputIsJoypad:
		$GamePad.show()
		$KB.hide()
	else:
		$GamePad.hide()
		$KB.show()
	pass
