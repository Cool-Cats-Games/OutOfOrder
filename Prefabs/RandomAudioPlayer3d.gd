extends AudioStreamPlayer3D

@export var sfx : Array[AudioStream]

func play_random(from_position: float = 0.0):
	stream = sfx.pick_random()
	super.play(from_position)
