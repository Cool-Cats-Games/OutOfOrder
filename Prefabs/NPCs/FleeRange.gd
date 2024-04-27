extends CharacterBody3D

func take_damage(_dmg, _dir, hitbox):
	var _from = hitbox.get_parent() if hitbox is Area3D else hitbox
	get_parent().set_state("Alert", {"from": _from.global_position})
	$"../flee_panic_timer".start(randf_range(1.0,5.0))
	pass
