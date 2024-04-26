extends Area3D


func on_room_loaded(room):
	if room.roomData.hasGoldenCat:
		queue_free()



func _on_body_entered(body):
	GameDataManager.gameData.goldenCats += 1
	Utils.get_world(get_tree()).set_room_data("hasGoldenCat", true)
	Utils.play_mono_sound("res://Sounds/sfx_goldenCat.wav", get_tree())
	get_tree().call_group("CollectibleUI", "get_golden_cat")
	queue_free()
	pass # Replace with function body.
