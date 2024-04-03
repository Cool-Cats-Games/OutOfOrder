extends Node2D

signal on_cancel()
signal on_confirm()
signal on_selected(btn)

var isOpen = false

func deselect():
	isOpen = false
	$DoorOpen.hide()
	$DoorClosed.show()
	$sfx_close.play()
	

func open():
	isOpen = true
	$DoorClosed.hide()
	$DoorOpen.show()
	$sfx_open.play()
	$Delay.start()


func _on_area_2d_body_entered(body):
	if not isOpen:
		open()
	pass # Replace with function body.


func _on_area_2d_body_exited(body):
	if isOpen:
		#deselect()
		on_cancel.emit()
	pass # Replace with function body.


func _on_delay_timeout():
	on_selected.emit(self)
	pass # Replace with function body.


func _on_button_pressed():
	if not isOpen:
		open()
	else:
		on_confirm.emit()
	pass # Replace with function body.
