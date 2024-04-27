extends "res://addons/CustomEvents/GenericEvent.gd"

@export var time = 1.0
@export var oneShot = false
@export var autoStart = false
@export var isDelay = false

var timer : Timer
var hasTriggered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(trigger)
	timer.one_shot = oneShot
	if autoStart:
		timer.start(time)
	pass # Replace with function body.

func start(_time = time):
	timer.start(_time)

func stop():
	timer.stop()

func trigger(by = null):
	if hasTriggered and isDelay:
		super.trigger()
	elif not isDelay:
		super.trigger()
	hasTriggered = true
	start()
