extends "res://addons/CustomEvents/GenericEvent.gd"

@export var time = 1.0
@export var oneShot = false
@export var autoStart = false
@export var isDelay = false #activates timer when triggered and will wait until the next time the timer goes off before triggering again

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
		if not oneShot:
			start()
	elif not isDelay:
		super.trigger()
		if not oneShot:
			start()
	hasTriggered = true
