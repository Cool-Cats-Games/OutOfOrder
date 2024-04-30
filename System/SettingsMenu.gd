extends CanvasLayer

signal on_queue_exit()

var prevSettings = {}
var firstFrame = true
var canClose = false

@onready var ControlContainer = $AspectRatio
@onready var MasterSlider = $AspectRatio/Column/ControlList/MasterControl
@onready var MusicSlider = $AspectRatio/Column/ControlList/MusicControl
@onready var EffectsSlider = $AspectRatio/Column/ControlList/SFXControl
@onready var FullscreenToggle = $AspectRatio/Column/ControlList/FullscreenControl/FullscreenToggle
@onready var ConfirmModal = $UI_Option

func _ready():
	firstFrame = true
	prevSettings = Settings.serialize_settings()
	MasterSlider.value = Settings.masterVolume
	MusicSlider.value = Settings.musicVolume
	EffectsSlider.value = Settings.sfxVolume
	FullscreenToggle.set_pressed_no_signal(Settings.isFullscreen)

func _process(delta):
	if firstFrame:
		firstFrame = false
		canClose = true
		$AspectRatio/Column/ControlList/MusicControl/Slider.grab_focus()
		return;

	if Input.is_action_just_pressed("ui_cancel") and not ConfirmModal.visible and canClose:
		ConfirmModal.initialize("Save Changes?")
		canClose = false

func cancel_settings():
	Settings.parse_settings_data(prevSettings)
	exit_settings()

func close_controls():
	process_mode = Node.PROCESS_MODE_ALWAYS
	ControlContainer.visible = true
	$AspectRatio/Column/ControlList/MusicControl/Slider.grab_focus()

func exit_settings():
	Settings.save_settings()
	await ConfirmModal.on_finished_conclude_sfx
	emit_signal("on_queue_exit")
	queue_free()

func open_controls():
	var clm = load("res://Prefabs/UI/ControlLayouts.tscn").instantiate()
	ControlContainer.visible = false
	add_child(clm)
	clm.connect("on_exit_queued", close_controls)
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_fullscreen_toggle_toggled(button_pressed):
	Settings.set_fullscreen(button_pressed)

func _on_music_control_value_changed( value ):
	Settings.set_music_volume(value);

func _on_sfx_control_value_changed( value ):
	Settings.set_sfx_volume( value );

func _on_back_button_pressed():
	ConfirmModal.initialize("Save Changes?")
	canClose = false


func _on_back_button_focus_entered():
	pass # Replace with function body.


func _on_master_control_value_changed( value ):
	Settings.set_master_volume(value)
	pass # Replace with function body.
