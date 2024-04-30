extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Transitions.fade_in()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$Transitions.fade_out()
	pass


func _on_transitions_on_fadeout_complete():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	pass # Replace with function body.
