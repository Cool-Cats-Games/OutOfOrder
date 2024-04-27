extends Control

var activeCombo = {} #Text:Text
@onready var textTweenList = $TextTweenList
@onready var decayBar = $ProgressBar
@onready var scoreDisplay = $Score

func _ready():
	self.visible=false
	if has_node("/root/ComboManager"):
		get_node("/root/ComboManager").register_ui(self)

func update_combo(dict):
	var comboLifetime = dict["combo_remaining"]
	var score = dict["current_score"]
	var comboEntries = dict["combo_items"]
	if comboEntries.size()==0:
		self.visible=false
		return
	else:
		self.visible=true
	#Recieve the current combo as a dict, compare to the active combo
	scoreDisplay.text = "[center]"+str(score)+"[/center]" #TODO replace with lerped incremental increase
	decayBar.value = comboLifetime
	clear_lines()
	var index = 0
	for line in comboEntries:
		add_line(line,"",str(comboEntries[line][1]),index)
		index += 1

func clear_lines():
	textTweenList.clear_lines()

func clear_combo():
	pass

func add_line(text1,text2,text3,number):
	textTweenList.add_entry(text1,text2,text3,number)
