extends Node2D

var idx = 0
var target_pos

func initialize(_idx):
	idx = _idx
	target_pos = 40 * idx

func _process(delta):
	position = position.lerp(Vector2(target_pos, 0.0), 0.1)

func update(_msg = {}):
	pass

func set_status(s = 1):
	match s:
		0:
			$Status.texture = null
		1:
			$Status.texture = load("res://Sprites/UI/ChallengeEmblems/ChallengeComplete.png")
			$AnimationPlayer.play("status")
