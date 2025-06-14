extends Node2D

# signals
signal changeScene
signal physics
signal visuals
signal vents

# level file path to load
var levelFilePath: String

# preloaded game element scenes
var playerScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Player.tscn")
#var guardScene: PackedScene = preload(
var sniperScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Sniper.tscn")
#var watcherScene: PackedScene = preload(
#var cameraScene: PackedScene = preload(
#var keyholderScene: PackedScene = preload(
#var trackerScene: PackedScene = preload(

# dictionaries
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
	loaded["player"] = loadEntities(levelData[4])
	await loaded["player"] == true
	if settings["enemiesEnabled"] == true:
		loadEntities(levelData[5])
	else:
		loaded["enemies"] == true
	await loaded["enemies"] == true
	if settings["interactablesEnabled"] == true:
		loadEntities(levelData[6])
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

func loadEntities(entityData):
	return true

func _map_loaded(map):
	# map is either "physics", "visuals" or "vents"
	loaded[map] = true

# await get_tree().create_timer(10).timeout
