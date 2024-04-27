extends State

@onready var hitbox = $"../../GatlingHitbox"

var firstFrame = false
var hitframes = 0
var ipVis = null

var bodiesHit = []

func enter(_msg := {}) -> void:
	super.enter(_msg)
	toggle_effects(true)
	hitbox.monitoring = true
	ipVis = actor.mainCamera.get_node("inputVisual")
	$"../../sfx_movement".pitch_scale = randf_range(0.9,1.1)
	$"../../sfx_start_move".pitch_scale = randf_range(0.9,1.0)
	$"../../sfx_stop_move".pitch_scale = randf_range(0.9,1.0)
	firstFrame = true
	hitframes = 0
	

func exit():
	super.exit()
	hitbox.monitoring = false
	toggle_effects(false)
	for b in bodiesHit:
		if is_instance_valid(b):
			b.apply_impulse(actor.global_position.direction_to(b.global_position) * 10)
			b.apply_torque_impulse(Vector3(10,10,10) * 5)
	bodiesHit = []

func update(_delta: float) -> void:
	if Input.is_action_just_released("grab"):
		state_machine.transition_to("Idle")

func physics_update(_delta: float) -> void:
	var inputDir = Vector3.ZERO
	inputDir.x = Input.get_axis("move_right", "move_left")
	inputDir.z = Input.get_axis("move_back", "move_forward")
	actor.localInputVector = inputDir.rotated(Vector3.UP, actor.mainCamera.rotation.y)
	if firstFrame:
		if actor.linear_velocity.dot(actor.localInputVector) < 0.5:
			if not $"../../sfx_start_move".playing:
				$"../../sfx_start_move".play()
		firstFrame = false
	ipVis.position = ipVis.position.lerp(inputDir * 2, 1.0)
	if inputDir.length() > 0.2:
		var ang = atan2(actor.localInputVector.x, actor.localInputVector.z)
		actor.rotation.y = ang
	if hitbox.has_overlapping_bodies():
		for b in hitbox.get_overlapping_bodies():
			if b.has_method("take_damage") and hitframes % 7 == 0 :
				b.take_damage(1, Vector3.ZERO, hitbox)
			if not b.get_collision_layer_value(8) and hitframes % 7 == 0:
				if not bodiesHit.has(b):
					bodiesHit.append(b)
				hitbox.combat_event.emit(hitbox.attackType) #Notify the ComboManager that a combo event occurred
				get_tree().call_group("MainCamera", "shake", 0.2)
				var he = hitbox.hitEffectResource.instantiate()
				Utils.get_world(get_tree()).add_child(he)
				he.position = hitbox.global_position.lerp(b.global_position, 0.5)
				actor.get_node("sfx_hit_ram").play_random()
		hitframes += 1
	else:
		hitframes = 0
	pass

func toggle_effects(s = true):
	$"../../GatlingSmorgasR".emitting = s
	$"../../GatlingSmorgasL".emitting = s

