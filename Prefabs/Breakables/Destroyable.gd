extends "res://Prefabs/Breakables/Breakable.gd"

@export var destroyedRes : String


func smash():
	super.smash()
	var des = load(destroyedRes).instantiate()
	Utils.get_world(get_tree()).add_child(des)
	des.global_transform = global_transform
