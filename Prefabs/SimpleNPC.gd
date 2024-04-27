extends "res://Prefabs/SimpleEnemy.gd"

func _ready():
	super._ready()
	print("NPC Ready")
	load_random_npc_skin()

func get_animation_controller():
	return $MeshContainer/AnimationPlayer

func walk_to(point):
	set_state("WalkTo", {"points": [point]})

func follow_path(points):
	set_state("WalkTo", {"points": points})

func load_random_npc_skin():
	var skinFolder = "res://Textures/characters/"
	var files = DirAccess.get_files_at(skinFolder)
	var pick = Array(files).pick_random()
	pick = pick.replace(".import", "")
	$MeshContainer/Armature/Skeleton3D/Mesh.material_override.albedo_texture = load(skinFolder + pick)

func _on_flee_panic_timer_timeout():
	get_tree().call_group("PatrolPath", "give_path_to", self)
	if randf() < 0.5:
		$StateMachine/WalkTo.points.reverse()
	$MeshContainer/AnimationPlayer.play("Flee")
	pass # Replace with function body.
