extends CanvasLayer

var modeResources : Array[Resource] = [
	preload("res://Prefabs/BallHog.tscn"),
	preload("res://Prefabs/CaptureTheFlag.tscn"),
	preload("res://Prefabs/DeliveryTime.tscn"),
	preload("res://Prefabs/Elimination.tscn"),
	preload("res://Prefabs/Goal.tscn"),
	preload("res://Prefabs/KingsCrown.tscn"),
	preload("res://Prefabs/MadGrab.tscn"),
	preload("res://Prefabs/PoisonBall.tscn")
]
var modifierResources = [
	preload("res://Prefabs/BigMode.tscn"),
	preload("res://Prefabs/MoonGravity.tscn"),
	preload("res://Prefabs/NotSoBigMode.tscn"),
	preload("res://Prefabs/BarrelRainModifier.tscn"),
	preload("res://Prefabs/StormShock.tscn"),
	preload("res://Prefabs/RubberDucks.tscn"),
]

var modifierInstances = []
var modeInstances = []

var nextMode = null
var modifierRolls = []

var tbq = 20
var maxmodifiers = 1

func _ready():
	#$TimeBetweenQueue.start()
	if SaveData.customGame.level != "Arcade" and SaveData.customGame.modes.size() > 0:
		load_modes()
	else:
		for r in modeResources:
			modeInstances.append(r.instantiate())
		for m in modifierResources:
			modifierInstances.append(m.instantiate())

func chance_reroll():
	var roll = randf()
	if (roll < 0.5) or SaveData.customGame.allModesAtOnce:
		reroll()
	else:
		end_queue()

func end_queue():
	$TimeBetweenQueue.start(tbq)
	ModeManager.start_game_tick()

func get_avaliable_modifiers():
	return modifierInstances.filter(
		func (m) : return not ModeManager.get_active_mode_types().has(m._get_class())
	)

func instance_mode_and_card():
	ModeManager.instantiate_mode(nextMode)
	ModeManager.register_mode(nextMode)
	lay_card(nextMode)

func lay_card(mode):
	get_tree().call_group("CardLayer", "lay_card", "res://Sprites/UI/ModeCards/" + mode.name + ".png", mode)

func load_modes():
	var modeRefs : Array[Resource] = []
	for m in SaveData.customGame.modes:
		var mod = load("res://Prefabs/" + m + ".tscn").instantiate()
		if mod is Modifier:
			modifierInstances.append(mod)
		else:
			modeInstances.append(mod)

func load_modifier():
	var mod = select_random_modifier()
	if not mod : return false
	nextMode = mod
	$CardSprite.texture = nextMode.get_card()
	$AnimationPlayer.play("Card")
	await $AnimationPlayer.animation_finished
	instance_mode_and_card()
	return true

func queue_mode():
	modifierRolls = []
	nextMode = select_random_mode()
	if nextMode == null: return end_queue()
	get_tree().call_group("CardLayer", "empty_card_display")
	$AnimationPlayer.play("GetReady")
	await $AnimationPlayer.animation_finished
	#load the mode
	$CardSprite.texture = nextMode.get_card()
	$AnimationPlayer.play("Card")
	await $AnimationPlayer.animation_finished
	if ModeManager.nonModifierActiveMode != null and ModeManager.nonModifierActiveMode != nextMode:
		ModeManager.nonModifierActiveMode.cleanup()
	if randf() < 1.1:
		#clear previous modifiers
		ModeManager.clear_modifiers()
		pass
	instance_mode_and_card()
	#select random amount of modifiers to load, between zero and n
	var avaliable_modifiers = get_avaliable_modifiers()
	var numMods = randi_range(0, min(avaliable_modifiers.size(), maxmodifiers))
	#loop x times, loading cards and modifiers, and playing the animation
	maxmodifiers += 1
	for i in range(numMods):
		if not await load_modifier():
			return end_queue()
	end_queue()
	pass

func reroll():
	nextMode = select_random_mode()
	if nextMode == null: return end_queue()
	$CardSprite.texture = nextMode.get_card()
	$AnimationPlayer.play("Card")

func select_random_mode():
	var filtered = modeInstances.filter(
		func (i) : return not ModeManager.get_active_mode_types().has(i._get_class())
	)
	var selected = filtered.pick_random()
	if selected == null:
		return null
	return selected.duplicate(7)

func select_random_modifier():
	var filtered = modifierInstances.filter(
		func (i) : return not ModeManager.get_active_mode_types().has(i._get_class())
	)
	var selected = filtered.pick_random()
	if selected == null:
		return null
	return selected.duplicate(7)

func start_time():
	$TimeBetweenQueue.start()
	AudioManager.queue_song(AudioManager.battletracks.pick_random(),false)

func _on_time_between_queue_timeout():
	queue_mode()
	pass # Replace with function body.
