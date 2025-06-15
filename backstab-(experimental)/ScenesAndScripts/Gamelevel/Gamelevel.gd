extends Node2D

# signals
signal changeScene
signal physics
signal visuals
signal vents

# level file path to load
var levelFilePath: String

# child nodes
@onready var physicsMap = $Physics
@onready var visualsMap = $Visuals
@onready var ventsMap = $Vents
@onready var entityList = $EntityList

# preloaded game element scenes
var playerScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Player.tscn")
#var guardScene: PackedScene = preload(
var sniperScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Sniper.tscn")
#var watcherScene: PackedScene = preload(
#var cameraScene: PackedScene = preload(
#var keyholderScene: PackedScene = preload(
#var trackerScene: PackedScene = preload(

# dictionaries
var entityScenes: Dictionary = {
	"player": playerScene,
	"sniper": sniperScene
	}
var entityInfo: Dictionary = {}
var settings: Dictionary = {
		"visualsEnabled": false,
		"ventsEnabled": false,
		"enemiesEnabled": false,
		"interactablesEnabled": false
		}
var loaded: Dictionary = {
		"setting": false, 
		"physics": false, 
		"visuals": false, 
		"vents": false, 
		"player": false, 
		"enemies": false, 
		"interactables": false
		}

# other variables

func _ready():
	# removable check if the file path is loaded in time
	#if levelFilePath == null:
	#	print("levelFilePath failed to load")
	#elif levelFilePath != null:
	#	print(levelFilePath)
	# loads file, makes sure it's loaded before proceeding
	var file = FileAccess.open(levelFilePath, FileAccess.READ)
	await file != null
	# turns file data into text, and then splits it into an array
	var content = file.get_as_text()
	var levelData = content.split("=====")
	#for i in levelData:
	#	print(i)
	# loads each part of levelData, and waits until each is loaded before continuing
	# if a part is not enabled, it is counted as loaded without acutally loading
	loaded["settings"] = loadSettings(levelData[0])
	await loaded["settings"] == true
	physics.emit(levelData[1])
	await loaded["physics"] == true
	if settings["visualsEnabled"] == true:
		visuals.emit(levelData[2])
	else:
		loaded["visuals"] = true
	await loaded["visuals"] == true
	if settings["ventsEnabled"] == true:
		vents.emit(levelData[3])
	else:
		loaded["vents"] = true
	await loaded["vents"] == true
	loaded["player"] = loadEntities(levelData[4], "player")
	await loaded["player"] == true
	if settings["enemiesEnabled"] == true:
		loadEntities(levelData[5], "enemies")
	else:
		loaded["enemies"] == true
	await loaded["enemies"] == true
	if settings["interactablesEnabled"] == true:
		loadEntities(levelData[6], "interactables")
	else:
		loaded["interactables"] == true
	await loaded["interactables"] == true

func _process(delta):
	pass

func loadSettings(settingsData):
	# splits the settings list into individual settings
	for i in settingsData.split(";"):
		# splits each setting into the name and state
		# then checks if the name of the setting matches any settings
		var settingParts = i.split(": ")
		var settingName: String = settingParts[0].strip_edges()
		# removes extras from actual setting
		var settingValue = settingParts[1].strip_edges()
		if settings[settingName] != null:
			#print(settingName + " is " + settingValue + ", and currently is " + str(settings[settingName]))
			# checks if actual setting value is convertible to a bool
			if settingValue == "true":
				settings[settingName] = true
			elif settingValue == "false":
				settings[settingName] = false
	return true

func loadEntities(entityData, entityGroup):
	var entitiesToSpawn = entityData.split("~~~~~")
	var entityType: String
	var entityId: String
	var direction: String
	var spawnCoordinates: String
	for i in entitiesToSpawn:
		var parts = i.split(":")
		var spawnData = parts[0].split(";")
		entityType = spawnData[0].strip_edges()
		entityId = spawnData[1].strip_edges()
		direction = spawnData[2].strip_edges()
		spawnCoordinates = spawnData[3].strip_edges()
	# if loading the player
	if entityGroup == "player":
		var entity = entityScenes[entityType]
		var player = entity.instantiate()
		entityInfo[entityId] = player
		player.id = entityId
		player.direction = direction
		# removes all characters that aren't number or commas from the coordinates
		for i in spawnCoordinates:
			if i == "(" or i == ")" or i == " ":
				spawnCoordinates.replace(i, "")
		# turns spawncoordinates into two number strings
		var coordXY = spawnCoordinates.split(",")
		# converts number strings to int and then creates a Vector2i with them
		var coordinates = Vector2i(int(coordXY[0]), int(coordXY[1]))
		# print(coordinates)
		player.global_position = physicsMap.map_to_local(coordinates)
		entityList.add_child(player)
	elif entityGroup == "enemies":
		var entity = entityScenes[entityType]
		var enemy = entity.instantiate()
		entityInfo[entityId] = enemy
		enemy.id = entityId
		enemy.direction = direction
		enemy.global_position = physicsMap.map_to_local(spawnCoordinates)

func _map_loaded(map):
	# map is either "physics", "visuals" or "vents"
	loaded[map] = true

# await get_tree().create_timer(10).timeout
