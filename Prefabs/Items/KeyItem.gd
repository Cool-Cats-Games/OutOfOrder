extends RigidBody3D

@export var itemName = ""
@export var canGrab = true
@export var pickupSound : AudioStream
@export var delayGrabable = false

func _ready():
	if delayGrabable:
		canGrab = false
		$delay.start()

func grab():
	queue_free()
	Utils.play_mono_sound(pickupSound, get_tree())
	GameDataManager.add_item(itemName, 1)

func _on_area_3d_body_entered(body):
	if canGrab:
		grab()
	pass # Replace with function body.


func _on_delay_timeout():
	canGrab = true
	if $Area3D.get_overlapping_bodies().size() > 0:
		grab()
	pass # Replace with function body.
