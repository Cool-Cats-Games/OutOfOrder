extends "res://Prefabs/SimpleEnemy.gd"

func get_animation_controller():
	return $PotatoShreds/AnimationPlayer


func _on_hitbox_body_entered(body):
	body.take_damage(global_position.direction_to(body.global_position))
	pass # Replace with function body.

func play_animation(anim_name):
	get_animation_controller().play(anim_name)
