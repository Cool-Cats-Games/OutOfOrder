extends Node

var gameData = preload("res://Data/GameDataResource.tres")
var newgameData

func _ready():
	gameData = load("res://Data/GameDataResource.tres").duplicate()

func add_item(itemName, ammount = 1):
	if not gameData.inventory.has(itemName):
		gameData.inventory[itemName] = ammount
	else:
		gameData.inventory[itemName] += ammount

func room_discovered(id):
	return gameData.rooms.has(id)

func update_room(id, roomdata):
	var discovered = gameData.rooms.has(id)
	gameData.rooms[id] = roomdata
	return discovered
