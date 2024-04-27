extends Node

var currentCombo = {}

var comboDisplay = null

var currentComboScore = 0
var totalScore = 0

var lifespan = 100
var startingDecay = 1 #Combo lasts 20 seconds by default
var decay = startingDecay
var decayIncrease = 1 #Amount decay increases during an active combo

func on_combat_event(eventText):
	add_instance(eventText)

func register_ui(ui):
	comboDisplay = ui

func add_instance(text):
	if currentCombo.size() == 0:
		decay = startingDecay
	if text in actionsDictionary:
		var info = actionsDictionary[text]
		var displayText = info[0]
		var score = info[1]
		currentComboScore += score
		if displayText in currentCombo:
			currentCombo[displayText][1] += 1
		else:
			currentCombo[displayText]= [score,1]
		lifespan = 100 #Reset the combo every time it gets updated
	else:
		print("Tried to register combo action not in dict: ",text)

func _process(delta):
	if currentCombo.size()==0:return
	#print(currentCombo,'\t',lifespan,'\t',decay)
	lifespan -= decay * delta
	decay += decayIncrease * delta
	if lifespan <= 0:
		currentCombo = {}
		totalScore += currentComboScore
		currentComboScore=0
	if comboDisplay != null:
		comboDisplay.update_combo(create_info_dict())

func create_info_dict():
	return {"combo_items":currentCombo,"combo_remaining":lifespan,"current_score":currentComboScore}

var actionsDictionary = { #Keeps track of actions, their display name, and how much score they're worth
	"light_attack":["Knuckle Sandwich",100],
	"heavy_attack":["The Walloper",200],
	"ram_attack":["Blizzard Blitz", 200],
	"died_breakable":["Mayohem",50],
	"slam_attack":["The 300-Pounder",400],
	"ice_cream":["Cold Shoulder",100],
	"died_tommytwotraps":["Fryer Fried",3000],
	"died_generic":["Foe Flattened",1000],
	"hover_attack":["Drip Zone", 100]
}
