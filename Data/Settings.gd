extends Node

var isFullscreen = true
var masterVolume = 0.45
var musicVolume = .45
var sfxVolume = .6

var currentScore = null
var bestScore = null

var lastInputIsJoypad = false

var version = 0.14

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
		parse_settings_data(serialize_settings())

func parse_settings_data(dat):
	if not dat.has("version"):
		save_settings()
		parse_settings_data(serialize_settings())
		return
	if dat.version < version:
		save_settings()
		parse_settings_data(serialize_settings())
		return
	version = dat.version
	set_master_volume(dat.masterVolume)
	set_music_volume(dat.musicVolume)
	set_sfx_volume(dat.sfxVolume)
	set_fullscreen(dat.isFullscreen)

func save_settings():
	var file = FileAccess.open("user://settings.ini", FileAccess.WRITE)
	file.store_line(JSON.stringify(serialize_settings()))

func serialize_settings() -> Dictionary:
	var settings = {}
	settings["masterVolume"] = masterVolume
	settings["musicVolume"] = musicVolume
	settings["sfxVolume"] = sfxVolume
	settings["isFullscreen"] = isFullscreen
	settings["version"] = version
	return settings

func set_music_volume(val):
	musicVolume = val
	AudioServer.set_bus_volume_db(3, convert_to_decibels(val))

func set_sfx_volume(val):
	sfxVolume = val
	AudioServer.set_bus_volume_db(2, convert_to_decibels(val))

func set_fullscreen(state):
	isFullscreen = state
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if isFullscreen else DisplayServer.WINDOW_MODE_WINDOWED)

func set_master_volume(val):
	masterVolume = val
	AudioServer.set_bus_volume_db(0, convert_to_decibels(val))
