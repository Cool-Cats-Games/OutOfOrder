extends Node3D

signal on_event_triggered()

@export var deleteAfterTrigger = false
@export var nextEvents : Array[NodePath]
@export var triggerOnReady = false

func _ready():
	if triggerOnReady:
		trigger(self)

func trigger(by = null):
	emit_signal("on_event_triggered")
	for e in nextEvents:
		get_node(e).trigger(by)
	if deleteAfterTrigger:
		queue_free()
