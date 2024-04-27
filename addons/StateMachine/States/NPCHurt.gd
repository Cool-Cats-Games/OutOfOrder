extends State

var hitboxPosition
var frames = 0
var hold = 10

func enter(_msg := {}) -> void:
	super.enter(_msg)
	var ac = actor.get_animation_controller()
	ac.play("Hurt" + str(randi_range(1,4)))
	frames = 0
	hitboxPosition = _msg.hitbox.global_position
	hold = 10 + ceili(_msg.dmg)

func update(_delta: float) -> void:
	frames += 1
	if frames == hold:
		state_machine.transition_to("Flee", {"from": hitboxPosition})
