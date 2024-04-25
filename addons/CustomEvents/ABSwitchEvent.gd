extends "res://addons/CustomEvents/GenericEvent.gd"

signal A_event_triggered
signal B_event_triggered

@export var alternate = false
@export var A_Event : NodePath
@export var B_Event : NodePath
@export var random  = false
@export var toggle = Switch.A
@export var weightA = 0.5

enum Switch {A, B}

var previousToggle

func trigger(by = null):
	super.trigger(by)
	if random:
		var roll = randf_range(0.0,1.0)
		var e = get_node(A_Event if roll < weightA else B_Event)
		if is_instance_valid(e):
			e.trigger(by)
		(A_event_triggered if roll < weightA else B_event_triggered).emit()
		previousToggle = toggle
	elif alternate:
		toggle = Switch.A if previousToggle == Switch.B else Switch.B
		trigger_toggle(by)
	else:
		trigger_toggle(by)

func trigger_toggle(by = null):
	var e = get_node(A_Event if toggle == Switch.A else B_Event)
	if is_instance_valid(e):
		e.trigger(by)
	(A_event_triggered if toggle == Switch.A else B_event_triggered).emit()
	previousToggle = toggle
