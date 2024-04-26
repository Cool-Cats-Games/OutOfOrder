extends "res://Prefabs/Challenges/ChallengeEmblems/ChallengeEmblem.gd"

func update(_msg = {}):
	$Label.text = str(_msg.goal - _msg.count)
