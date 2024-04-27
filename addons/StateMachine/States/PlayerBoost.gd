extends State

@onready var hitbox = $"../../RamHitbox"

func enter(_msg = {}):
	super.enter(_msg)
	print("boosting")
	hitbox.damage_calculation = hitbox.velocity_damage
	hitbox.monitoring = true
	actor.linear_velocity.y = 0.0
	get_tree().get_first_node_in_group("MainCamera").set_fov(90.0)

func exit():
	super.exit()
	get_tree().get_first_node_in_group("MainCamera").set_fov(75.0)
	hitbox.monitoring = false

func physics_update(_delta):
	actor.apply_force(actor.transform.basis.z * actor.boostSpeed)
	actor.boost -= 3.0
	if actor.boost <= 0.0:
		actor.boost = 0.0
		actor.canBoost = false
		state_machine.transition_to("Idle")
