extends AudioStreamPlayer3D

@export var sfx : Array[AudioStream]

var freeOnFinish = true

func play_random(from_position: float = 0.0):
	stream = sfx.pick_random()
	super.play(from_position)

func configure( _sfx, pos = Vector3.ZERO, vol = 0.0, pitch = 1.0, free_after_finish = true):
	if _sfx is AudioStream:
		sfx = [_sfx]
	if _sfx is Array:
		sfx = _sfx
	position = pos
	volume_db = vol
	pitch_scale = pitch
	freeOnFinish = free_after_finish


func _on_finished():
	if freeOnFinish:
		queue_free()
	pass # Replace with function body.
