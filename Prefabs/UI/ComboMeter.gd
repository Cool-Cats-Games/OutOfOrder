extends Control

var activeCombo = {} #Text:Text
@onready var textTweenList = $TextTweenList
@onready var decayBar = $ProgressBar
@onready var scoreDisplay = $TextTweenList/Total/Score
@onready var fireParticles = $fire_particles_2

var canSpecial = true
var isShown = false
var score = 0

func _ready():
	hide_ui()
	if has_node("/root/ComboManager"):
		get_node("/root/ComboManager").register_ui(self)

func update_combo(dict):
	var comboLifetime = dict["combo_remaining"]
	var _score = dict["current_score"]
	var comboEntries = dict["combo_items"]
	if comboEntries.size()==0:
		combo_ended()
		hide_ui()
		return
	elif not isShown:
		show_ui()
		$sfx_combo_start.play()
	if (score >= ComboManager.specialThreshold) and (not fireParticles.emitting) and (_score != score):
		on_special_threshold()
	score = _score
	#Recieve the current combo as a dict, compare to the active combo
	scoreDisplay.text = str(score) #TODO replace with lerped incremental increase
	decayBar.value = comboLifetime
	clear_lines()
	var index = 0
	for line in comboEntries:
		add_line(line,str(comboEntries[line][0]),str(comboEntries[line][1]),index)
		index += 1

func clear_lines():
	textTweenList.clear_lines()

func clear_combo():
	pass

func combo_ended():
	canSpecial = true
	score = 0
	fireParticles.emitting = false

func add_line(text1,text2,text3,number):
	textTweenList.add_entry(text1,text2,text3,number)

func on_special_threshold():
	if canSpecial:
		fireParticles.emitting = true
		$sfx_special.play()
		canSpecial = false

func hide_ui():
	isShown = false
	for c in get_children():
		if c != fireParticles and c.has_method("hide"):
			c.hide()
	fireParticles.emitting = false

func show_ui():
	isShown = true
	for c in get_children():
		if c.has_method("show"):
			c.show()
	
