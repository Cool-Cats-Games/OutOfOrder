extends Node3D


@export var targetPath : NodePath

var target
var cameraDragging = false
var damp = 0.2
var fov = 75.0
var zoomFactor = -7.0
var zoomMax = -15.0
var zoomMin = -5.0

func _ready():
	target = get_node(targetPath)

func _input(event):
	if event is InputEventMouseMotion and cameraDragging:
		rotation.y = lerp(rotation.y, rotation.y - event.relative.x * damp, 0.01)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position.x = lerp(global_position.x, target.global_position.x, damp)
	global_position.z = lerp(global_position.z, target.global_position.z, damp)
	global_position.y = lerp(global_position.y, target.global_position.y, damp * 0.2)
	var joyRot = Input.get_axis("camera_left", "camera_right")
	rotation.y = lerp(rotation.y, rotation.y + joyRot, 0.05)
	update_camera_angle()
	update_camera_zoom()
	$A/B/Camera.fov = lerp($A/B/Camera.fov, fov, 0.1)
	cameraDragging = Input.is_action_pressed("dragCamera")
	$A/B/Camera.position = $A/B/Camera.position.lerp(Vector3.ZERO, 0.1)
	pass

func shake():
	$A/B/Camera.position += Vector3(randf_range(-0.5,0.5),randf_range(-0.5,0.5),randf_range(-0.5,0.5))

func set_fov(_fov):
	fov = _fov

func update_camera_angle():
	var h = $A/B.position.y
	var d = $A.position.z
	var angle = asin(h/$A/B.global_position.distance_to(global_position))
	$A/B/Camera.rotation.x = lerp($A/B/Camera.rotation.x, -angle, 0.05)

func update_camera_zoom():
	var deltaZoom = 1.0 if Input.is_action_just_pressed("zoomIn") else (-1.0 if Input.is_action_just_pressed("zoomOut") else 0.0)
	zoomFactor = clamp(zoomFactor + (deltaZoom * 2.5), zoomMax, zoomMin)
	$A.position.z = lerp($A.position.z, zoomFactor, 0.1)
