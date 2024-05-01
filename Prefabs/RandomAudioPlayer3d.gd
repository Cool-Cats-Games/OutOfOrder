extends AudioStreamPlayer3D

@export var sfx : Array[AudioStream]
@export var playGlobal = false
@export var limitOne = false

var freeOnFinish = true

func _ready():
	if autoplay:
		play_random()


func play_random(from_position: float = 0.0):
	if (limitOne and playing) and not playGlobal:
		return
	if sfx.size() == 0:
		return
	stream = sfx.pick_random()
	if playGlobal:
		Utils.play_sound_at(stream, get_tree(), global_position, volume_db, pitch_scale, freeOnFinish, attenuation_model)
	else:
		super.play(from_position)

func configure( _sfx, pos = Vector3.ZERO, vol = 0.0, pitch = 1.0, free_after_finish = true, attentuationModel = 0):
	if _sfx is String:
		sfx = [load(_sfx)]
	elif _sfx is AudioStream:
		sfx = [_sfx]
	elif _sfx is Array:
		sfx = _sfx
	position = pos
	volume_db = vol
	pitch_scale = pitch
	attenuation_model = attentuationModel
	bus = "SFX"
	freeOnFinish = free_after_finish


func _on_finished():
	if freeOnFinish:
		queue_free()
	pass # Replace with function body.
