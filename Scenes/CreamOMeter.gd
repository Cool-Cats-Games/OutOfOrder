extends Sprite2D

@onready var player = get_tree().get_first_node_in_group("Player")


func _process(_delta):
	if is_instance_valid(player):
		material.set_shader_parameter("fV", lerp(0.1,0.9,player.get_ice_cream_fv()))
		if player.creamDepleted and not $AnimationPlayer.is_playing():
			$AnimationPlayer.play("creamdepleted")

func _on_animation_player_animation_finished(anim_name):
	if is_instance_valid(player):
		player.creamDepleted = false
		player.cream = 0.1
	pass # Replace with function body.

func combo_ended():
	$"../fire_particles_2".emitting = false

func on_special_threshold():
	$"../fire_particles_2".emitting = true
