extends Control

signal confirm()
signal cancel()

signal on_finished_conclude_sfx()

var inputbuffer = false

@onready var ConfirmButton = $PanelContainer/VBoxContainer/HBoxContainer/Confirm
@onready var CancelButton = $PanelContainer/VBoxContainer/HBoxContainer/Cancel
@onready var ModalText = $PanelContainer/VBoxContainer/Label

func initialize(text = "Accept?", pos = position):
	visible = true
	position = pos
	
	ModalText.text = text
	ModalText.visible_ratio = 0.0
	ConfirmButton.grab_focus()
	
	inputbuffer = false
	
	$sfx_init.play()
	$sfx_confirm.connect("finished", sfx_done, 4)
	$sfx_cancel.connect("finished", sfx_done, 4)
	
func clear():
	visible = false
	ConfirmButton.release_focus()
	CancelButton.release_focus()

func sfx_done():
	emit_signal("on_finished_conclude_sfx")

func _process(delta):
	if inputbuffer:
		ModalText.visible_ratio = lerp(ModalText.visible_ratio, 1.1, 0.3)
		if Input.is_action_just_pressed("ui_cancel") and visible:
			cancel.emit()
			$sfx_cancel.play()
	else:
		inputbuffer = true


func _on_confirm_pressed():
	emit_signal("confirm");


func _on_cancel_pressed():
	emit_signal("cancel");
