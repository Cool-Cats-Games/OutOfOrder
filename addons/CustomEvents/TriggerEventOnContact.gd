extends Area3D

signal on_event_triggered()

@export var deleteAfterTrigger = false
@export var nextEvents : Array[NodePath]
@export var triggerOnReady = false

func _ready():
	if triggerOnReady:
		trigger(self)

func trigger(by = null):
	on_event_triggered.emit()
	for e in nextEvents:
		get_node(e).trigger(by)
	if deleteAfterTrigger:
		queue_free()


func _on_body_entered(body):
	trigger()
	pass # Replace with function body.
