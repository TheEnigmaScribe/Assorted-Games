extends Node2D

signal changeScene

#signal loadPhysics
#signal loadVisuals
#signal loadVents
#signal pathReceived
#signal connectToPlayer
#signal connectToEnemies
#signal instructionsFilled
#signal gameOver
#signal levelComplete

@onready var physicsMap = $PhysicsTilemap

var levelFilePath: String

# preloaded scenes
var playerScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Player.tscn")
var sniperScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Sniper.tscn")
# var guardScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Guard.tscn")
# var watcherScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Watcher.tscn")
# var cameraScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Camera.tscn")
# var keyholderScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Keyholder.tscn")
# var trackerScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Tracker.tscn")

var loadingDone = false
var loadedList: Dictionary = {"levelData": false, "settings": false, "physics": false, "visuals": false, "vents": false, "player": false, "enemies": false, "interactables": false}
var mapLoaded: bool = false

var levelData: Array

var levelFile: String
var firstTrigger: bool = true
var secondFillCheck: bool = false

var settings: Dictionary = {}
var entityInfo: Dictionary = {}

func _ready():
	print(levelFilePath)
	# Global.returnedLevelPath.connect(_path_set)
	# print(folderPath)
	# loadMap(FileAccess.open("res://MapFiles/EntityMap1.txt", FileAccess.READ))
	# loadInstructions(FileAccess.open("res://Mapfiles/EnemyInstructions1.txt", FileAccess.READ))
	# entityInfo["isWorking"] = "testvalue"
	pass

#func _path_set(file):
#	if firstTrigger == false:
#		return
#	firstTrigger = false
#	levelFile = file
#	pathSet = true
#	var counter = 0
#	await get_tree().create_timer(1).timeout
#	pathReceived.emit()
#	var levelAsTextFile = FileAccess.open(levelFile, FileAccess.READ)
#	var levelAsText = levelAsTextFile.get_as_text()
#	levelData = levelAsText.split("=====")

#func _load_file(file):
#	pass
	# load settings
	#loadedList["settings"] = true
	#if loadedList["settings"] == true:
		# load physicsTilemap
	#	loadPhysics.emit(levelData[1])
	#	while loadedList["physics"] == false:
	#		await get_tree().create_timer(0.1).timeout
	#		print("waiting for physics...")
		
		# if enabled, load visualsTilemap
	#	if settings["visualsTilemap"] == true:
	#		loadVisuals.emit(levelData[2])
	#	else:
	#		loadedList["visuals"] = true
	#	while loadedList["visuals"] == false:
	#		await get_tree().create_timer(0.1).timeout
	#		print("waiting for visuals...")
	
		# if enabled, load ventsTilemap
	#	if settings["ventsTilemap"] == true:
	#		loadVents.emit(levelData[3])
	#	else:
	#		loadedList["vents"] = true
	#	while loadedList["vents"] == false:
	#		await get_tree().create_timer(0.1).timeout
	#		print("waiting for vents...")
	
		# load player
	#	loadEntities(levelData[4], "player")
		# if enabled, load enemies
	#	if settings["enemies"] == true:
	#		loadEntities(levelData[5], "enemy")
		# if enabled, load interactables
	#	if settings["interactables"] == true:
	#		loadEntities(levelData[6], "interactable")
	
	# if line.is_empty():
			# continue

#func _process(_delta):
#	if loadingDone == false:
#		_load_file(levelFile)
#	if loadedList["levelData"] == false:
#		return
#	if loadedList["settings"] == false:
#		loadSettings(levelData[0])
#		return
#	elif loadedList["physics"] == false:
#		loadPhysics.emit(levelData[1])
#		return
#	elif loadedList["visuals"] == false:
#		loadVisuals.emit(levelData[2])
#		return
#	elif loadedList["vents"] == false:
#		loadVents.emit(levelData[3])
#		return
#	elif loadedList["player"] == false:
#		loadEntities(levelData[4], "player")
#		return
#	elif loadedList["enemies"] == false:
#		loadEntities(levelData[5], "enemy")
#		return
#	elif loadedList["interactables"] == false:
#		loadEntities(levelData[6], "interactable")
#		return
	#if loadedList["settings"] == true:
	#	loadPhysics.emit(levelData[1])
	#	while loadedList["physics"] == false:
	#		await get_tree().create_timer(0.1).timeout
	#		print("waiting for physics...")
	#elif loadedList["physics"] == true and settings["visuals"] == true:
	#	loadVisuals.emit(levelData[2])
	#	while loadedList["visuals"] == false:
	#		await get_tree().create_timer(0.1).timeout
	#		print("waiting for physics...")
	#elif loadedList["visuals"] == true and settings["vents"] == true:
	#	loadVents.emit(levelData[3])
	#	while loadedList["vents"] == false:
	#		await get_tree().create_timer(0.1).timeout
	#		print("waiting for vents...")
	#elif loadedList["vents"] == true:
	#	print("worked")
	
#	if secondFillCheck == false:
#		for i in 10:
#			if i == 9:
#				instructionsFilled.emit()
#				secondFillCheck = true
#	if mapLoaded == false:
#		return
#	if Input.is_action_just_pressed("escape"):
#		print("escape pressed")
#	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
#		get_tree().paused = true
#		print("paused")
#	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
#		get_tree().paused = false
#		print("unpaused")

#func loadSettings(data):
#	for i in (data[0]).split(";"):
#		var parts: Array = i.split(":")
#		parts[1] = parts[1].strip_edges()
#		if parts[1] == "true":
#			parts[1] = true
#		elif parts[1] == "false":
#			parts[1] = false
#		settings[parts[0]] = parts[1]
#		print(parts[0] + ": " + settings[parts[0]])

#func loadEntities(entity: String, entityGroup: String):
	# splits list of entities in each part into individual entites
#	var entityList: Array = entity.split("~~~~~")
#	for e in entityList:
#		# split on colon to seperate extra data from spawning data if any
#		var entityData = e.split(":")
#		# split spawning data into seperate parts
#		var entityElements = entityData[0].split(";")
#		var entityType: String = entityElements[0]
#		var entityID: String = entityElements[1]
#		var entityDirection: String = entityElements[2]
#		var entitySpawn = entityElements[3]
#		if entityGroup == "player":
#			var player = playerScene.instantiate()
#			entityInfo[entityID] = player
#			entityInfo[entityID + "direction"] = entityDirection
#			player.global_position = physicsMap.local_to_map(player.global_position)
#			entitySpawn = entitySpawn.split(",")
#			entitySpawn = Vector2i(entitySpawn[0], entitySpawn[1])
#			player.global_position = physicsMap.map_to_local(entitySpawn)
#			pass
#		elif entityGroup == "enemy":
#			pass
#		elif entityGroup == "interactable":
#			pass
	#		elif i == "P":
	#			var player = playerScene.instantiate()
	#			$EntityList.add_child(player)
	#			player.position = Vector2((xCoord * 32) + 16, (yCoord * 32) + 16)
	#		elif i == "S":
	#			# var enemyID = "S" + str(sniperNum) 
	#			var sniper = sniperScene.instantiate()
	#			sniper.position = Vector2((xCoord * 32) + 16, (yCoord * 32) + 16)
	#			$EntityList.add_child(sniper)
	#			# sniper.name = enemyID
	#			# entityInfo stores all enemy info, though in seperate entries
	#			# each entry is the appropriate string and then the enemy ID
	#			# entityInfo["Instance" + enemyID] = sniper
	#			sniper.instPath = sniper
	#			# sniper.id = enemyID
	#			sniper.add_to_group("enemies")
	#			# print("sniper.id is " + sniper.id)
	#			# sniperNum += 1
	#		elif i == "X":
	#			connectToPlayer.emit()
	#			connectToEnemies.emit()
	#			for e in get_tree().get_nodes_in_group("enemies"):
	#				e.playerSeen.connect(_level_lose)
	#			for p in get_tree().get_nodes_in_group("player"):
	#				if p is Sprite2D:
	#					p.reachedGoal.connect(_level_win)
#	pass


#func _level_lose():
#	print("gameOver")
#	gameOver.emit()
	# play player death animation and screen transition, and have those signal when they're done
	# save player stats
#	restartScreen()

#func _level_win():
	# level ending sequence probably has player walking off through the exit to elsewhere
	# enemies possibly relax or something like that, but not necessarily
	# things like snipers bringing up their guns and pointing em up as if done
	# save player stats
#	print("level completed")
#	levelComplete.emit()

# possible thing to implement
#func _go_on_alert():
#	pass

#func restartScreen():
#	pass
	# get_tree().change_scene_to_file()




#func _tilemap_loaded(tilemapType: String):
#	if tilemapType == "physics":
#		loadedList["physics"] = true
#	elif tilemapType == "visuals":
#		loadedList["visuals"] = true
#	elif tilemapType == "vents":
#		loadedList["vents"] = true
