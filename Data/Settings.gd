extends Node

var isFullscreen = false
var musicVolume = .5
var sfxVolume = .6

var currentScore = null
var bestScore = null

var lastInputIsJoypad = false

func _ready():
	load_settings()

func _input(event):
	if event is InputEventJoypadButton:
		lastInputIsJoypad = true
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.4:
			lastInputIsJoypad = true
	elif event is InputEventMouseButton or event is InputEventKey:
		lastInputIsJoypad = false
	elif event is InputEventMouseMotion:
		if event.relative > Vector2.ONE:
			lastInputIsJoypad = false

func convert_to_decibels(value):
	return 20.0 * (log(value) / log(10))

func load_settings():
	if FileAccess.file_exists("user://settings.ini"):
		var file = FileAccess.open("user://settings.ini", FileAccess.READ)
		var content = file.get_as_text()
		var settingData = JSON.parse_string(content)
		parse_settings_data(settingData)
	else:
		save_settings()

func parse_settings_data(dat):
	set_music_volume(dat.musicVolume)
	set_sfx_volume(dat.sfxVolume)
	set_fullscreen(dat.isFullscreen)

func save_settings():
	var file = FileAccess.open("user://settings.ini", FileAccess.WRITE)
	file.store_line(JSON.stringify(serialize_settings()))

func serialize_settings() -> Dictionary:
	var settings = {}
	settings["musicVolume"] = musicVolume
	settings["sfxVolume"] = sfxVolume
	settings["isFullscreen"] = isFullscreen
	return settings

func set_music_volume(val):
	musicVolume = val
	AudioServer.set_bus_volume_db(1, convert_to_decibels(val))

func set_sfx_volume(val):
	sfxVolume = val
	AudioServer.set_bus_volume_db(2, convert_to_decibels(val))

func set_fullscreen(state):
	isFullscreen = state
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if isFullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	
