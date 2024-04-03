class_name State
extends Node

@export var sfx : Array[AudioStream]

var actor = null
var animationController = null
var state_machine: StateMachine = null

signal state_entered()
signal state_exited()

# Virtual function. Receives events from the `_unhandled_input()` callback.
func handle_input(_event: InputEvent) -> void:
	pass

# Virtual function. Corresponds to the `_process()` callback.
func update(_delta: float) -> void:
	pass

# Virtual function. Corresponds to the `_physics_process()` callback.
func physics_update(_delta: float) -> void:
	pass

# Virtual function. Called by the state machine upon changing the active state. The `msg` parameter
# is a dictionary with arbitrary data the state can use to initialize itself.
func enter(_msg := {}) -> void:
	emit_signal("state_entered")
	if actor.has_method("play_sound") and sfx.size() > 0:
		actor.play_sound(sfx.pick_random())
	pass

# Virtual function. Called by the state machine before changing the active state. Use this function
# to clean up the state.
func exit() -> void:
	emit_signal("state_exited")
	pass

#Virtual function to add unique, per state behavior for testing if its possible to enter the state
func test() -> bool:
	return true

func test_exit() -> bool:
	return true
