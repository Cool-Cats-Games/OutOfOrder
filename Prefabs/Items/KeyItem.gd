extends RigidBody3D

signal on_item_pickup()

@export var itemName = ""
@export var canGrab = true
@export var pickupSound : AudioStream
@export var delayGrabable = false
@export var deletePermenant = false

func _ready():
	if delayGrabable:
		canGrab = false
		$delay.start()

func grab():
	on_item_pickup.emit()
	if deletePermenant:
		Utils.get_world(get_tree()).register_instance_deleted(get_path())
	queue_free()
	Utils.play_mono_sound(pickupSound, get_tree(), 3.0)
	GameDataManager.add_item(itemName, 1)
	get_tree().call_group("World", "set_room_data", itemName, true)

func _on_area_3d_body_entered(body):
	if canGrab:
		grab()
	pass # Replace with function body.


func _on_delay_timeout():
	canGrab = true
	if $Area3D.get_overlapping_bodies().size() > 0:
		grab()
	pass # Replace with function body.
