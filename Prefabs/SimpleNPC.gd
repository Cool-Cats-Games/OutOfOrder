extends "res://Prefabs/SimpleEnemy.gd"

@onready var headBone = $MeshContainer/Armature/Skeleton3D/Hair
@onready var hairMesh = $MeshContainer/Armature/Skeleton3D/Hair/Hair
@onready var bodyMesh = $MeshContainer/Armature/Skeleton3D/Mesh

var customName = ""

func _ready():
	super._ready()
	load_random_body()
	load_random_hair()
	load_random_npc_skin()
	set_name(customName)

func get_animation_controller():
	return $MeshContainer/AnimationPlayer

func flee_on_patrol():
	request_patrol_path()
	if randf() < 0.5:
		$StateMachine/WalkTo.points.reverse()
	$StateMachine/WalkTo.callback = panic
	get_animation_controller().play("Flee")

func follow_path(points):
	set_state("WalkTo", {"points": points})

func load_random_body():
	var modelFolder = "res://Models/Characters/NPCs/NPCMeshes/"
	var files = DirAccess.get_files_at(modelFolder)
	var pick = Array(files).pick_random()
	pick = pick.replace(".remap", "")
	bodyMesh.mesh = load(modelFolder + pick)
	customName += pick.split(".")[0]

func load_random_hair():
	var modelFolder = "res://Models/Characters/NPCs/NPCHairMeshes/"
	var files = DirAccess.get_files_at(modelFolder)
	var pick = Array(files).pick_random()
	pick = pick.replace(".remap", "")
	hairMesh.mesh = load(modelFolder + pick)
	customName += "-" + pick.split(".")[0]

func load_random_npc_skin():
	var skinFolder = "res://Textures/characters/"
	var files = DirAccess.get_files_at(skinFolder)
	var pick = Array(files).pick_random()
	pick = pick.replace(".import", "")
	var tex = load(skinFolder + pick)
	bodyMesh.material_override.albedo_texture = tex
	hairMesh.material_override.albedo_texture = tex
	customName += "-" + pick.split(".")[0]

func panic(from = global_position + Vector3(randf_range(-1.0,1.0),randf_range(-1.0,1.0),randf_range(-1.0,1.0))):
	set_state("Alert", {"from": from})
	$flee_panic_timer.start(randf_range(1.0,5.0))

func play_animation(animName):
	get_animation_controller().play(animName)

func request_patrol_path():
	get_tree().call_group("PatrolPath", "give_path_to", self)

func walk_to(point):
	set_state("WalkTo", {"points": [point]})

func _on_flee_panic_timer_timeout():
	flee_on_patrol()
	pass # Replace with function body.

