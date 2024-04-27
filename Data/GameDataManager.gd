extends Node

var gameData = preload("res://Data/GameDataResource.tres")

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
