extends "res://addons/CustomEvents/GenericEvent.gd"

func trigger(by = null):
	super.trigger(by)
	AudioManager.stop()
