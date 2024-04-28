extends Node2D

signal on_fire()
var msg = {}



func fire(at = position, _msg = {}):
	msg = _msg
	position = at
	emit_signal("on_fire")
