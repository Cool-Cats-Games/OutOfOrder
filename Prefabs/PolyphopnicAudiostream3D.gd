extends "res://Prefabs/RandomAudioPlayer3d.gd"

var avaliableChannels = []

func _ready():
	for c in get_children():
		avaliableChannels.append(c)

func play_random(from_position: float = 0.0):
	if sfx.size() == 0:
		return
	if not is_playing():
		#main channel is avaliable
		stream = sfx.pick_random()
		play(from_position)
	elif avaliableChannels.size() != 0:
		#already playing, load onto an avaliable channel
		var channel = avaliableChannels.pop_back()
		configure_channel(channel, sfx.pick_random())
		channel.play()
	elif get_child_count() < max_polyphony:
		#create new channel
		var c = AudioStreamPlayer3D.new()
		configure_channel(c, sfx.pick_random())
		add_channel(c)
		c.play()
	else:
		#full, override main channel
		stream = sfx.pick_random()
		play(from_position)

func add_channel(channel : AudioStreamPlayer3D):
	add_child(channel)
	channel.finished.connect(make_channel_avaliable.bind(channel))

func configure_channel(c : AudioStreamPlayer3D, _stream = stream):
	c.stream = _stream
	c.volume_db = volume_db
	c.unit_size = unit_size
	c.max_db = max_db
	c.pitch_scale = pitch_scale
	c.max_distance = max_distance
	c.panning_strength = panning_strength
	c.bus = bus

func make_channel_avaliable(channel):
	if not avaliableChannels.has(channel):
		avaliableChannels.append(channel)
