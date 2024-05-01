extends "res://addons/CustomEvents/GenericEvent.gd"
#squibs as a dictionary. 
#key is path to the resource of the squib,
#value is an int of the number to generate. use negative numbers for random range
#E.G. :
#{"path_to_"squib_resource" : 3}
@export var squibs = {}
@export var randomTTL = true
@export var allowZero = false

func trigger(by = null):
	super.trigger(by)
	for s in squibs:
		var sres = load(s)
		var n = squibs[s]
		if n < 0:
			n = randi_range((0 if allowZero else 1), abs(n))
		for i in range(0,n):
			spawn_squib(sres)

func spawn_squib(sres):
	var sobj : RigidBody3D = sres.instantiate()
	sobj.set_collision_layer_value(1, false)
	sobj.set_collision_layer_value(6, true)
	sobj.freeze = false
	Utils.get_world(get_tree()).add_child(sobj)
	sobj.transform = global_transform
	sobj.apply_force(Vector3(randf_range(-1.0,1.0) * 50, randf_range(10,50) * 5, randf_range(-1.0,1.0) * 50))
	sobj.apply_torque(Vector3(randf_range(-1.0,1.0) * 5, randf_range(-1.0,1.0), randf_range(-1.0,1.0) * 5))
	var ttl = sobj.get_node("TTL")
	if randomTTL and is_instance_valid(ttl):
		ttl.start(randf_range(1.0,6.0))

func trigger_squib_spawn():
	trigger()

