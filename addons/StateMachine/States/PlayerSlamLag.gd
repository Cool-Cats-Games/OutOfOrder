extends State

var maxFramesActive = 10
var frames = 0

func enter(_msg := {}) -> void:
	super.enter(_msg)
	if not _msg.has("skipHitbox"):
		$"../../SlamHitbox".monitoring = true
	actor.get_character_model().play_animation("SlamBounce")
	$Timer.start()
	frames = 0

func exit():
	super.exit()
	$"../../SlamHitbox".monitoring = false

func update(_delta: float) -> void:
	frames += 1
	if frames >= maxFramesActive:
		$"../../SlamHitbox".monitoring = false
