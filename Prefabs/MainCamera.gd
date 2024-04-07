extends Camera3D

var target
var proximity = 7
var projectedposition = Vector3.ZERO

# Camera parameters
var movementSensitivity = 0.2
var height : float = 2.0  # Height of the camera above the target
var distance : float = 10.0  # Distance from the target
var angle_degrees : float = 0.0  # Angle to look at from above the target
var isCameraDragging = false
var mouseMovement = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_tree().get_first_node_in_group("Player")
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		mouseMovement = event.relative

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mouseMovement = lerp(mouseMovement, Vector2.ZERO, 0.5)
	if target:
		isCameraDragging = Input.is_action_pressed("dragCamera")
		if isCameraDragging:
			height = lerp(height, clamp(height + Input.get_last_mouse_velocity().y,1.0,6.0), movementSensitivity * 0.2)
			angle_degrees = lerp(angle_degrees, angle_degrees - (Input.get_last_mouse_velocity().x * 0.2), movementSensitivity * 0.05)
			pass
		var deltaZoom = 0.0
		deltaZoom += 2.0 if Input.is_action_just_pressed("zoomOut") else (-2.0 if Input.is_action_just_pressed("zoomIn") else 0.0)
		distance = lerp(distance, distance + deltaZoom, movementSensitivity)
		var camera_position = target.global_position + Vector3(0, height, 0)
		var offset = Vector3(0, 0, -distance).rotated(Vector3(0, 1, 0), deg_to_rad(angle_degrees))
		camera_position += offset

		# Set the camera position
		global_position = global_position.lerp(camera_position, movementSensitivity)

		var rotT = global_transform.looking_at(target.global_position)
		set_global_transform(global_transform.interpolate_with(rotT, movementSensitivity))
		rotation.z = 0.0
	pass
