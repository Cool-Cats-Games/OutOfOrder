extends Node

var gameData = load("res://Data/GameDataResource.tres")

func room_discovered(id):
	return gameData.rooms.has(id)

func update_room(id, roomdata):
	var discovered = gameData.rooms.has(id)
	gameData.rooms[id] = roomdata
	return discovered
