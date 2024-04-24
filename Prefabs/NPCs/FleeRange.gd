extends CharacterBody3D

func take_damage(dmg, dir, hitbox):
	get_parent().set_state("Alert", {"from": hitbox.get_parent().global_position})
	pass
