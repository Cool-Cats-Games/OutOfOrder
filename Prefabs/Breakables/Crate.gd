extends "res://Prefabs/Breakables/Breakable.gd"

#crate will search its children for a squib release event to trigger and trigger all of them on smash

func _ready():
	super._ready()
	for c in get_children():
		if c.has_method("trigger_squib_spawn"):
			on_smashed.connect(c.trigger_squib_spawn)
