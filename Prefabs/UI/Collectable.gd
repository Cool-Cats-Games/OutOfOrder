extends Node2D

var before = 0
var after = 0

func get_golden_cat():
	$Container/Cat.show()
	collect(GameDataManager.gameData.goldenCats)

func collect(count):
	before = count - 1
	after = count
	$Container/Label.text = str(before)
	$AnimationPlayer.play("get")

func update_label_text():
	$AudioStreamPlayer.play()
	$Container/Label.text = str(after)
