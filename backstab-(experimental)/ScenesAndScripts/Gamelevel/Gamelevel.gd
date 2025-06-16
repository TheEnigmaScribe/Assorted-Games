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
# player
var playerScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Player.tscn")

# enemies
#var guardScene: PackedScene = preload(
var sniperScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Enemies/Sniper.tscn")
#var watcherScene: PackedScene = preload(
#var cameraScene: PackedScene = preload(
#var keyholderScene: PackedScene = preload(
#var trackerScene: PackedScene = preload(

# interactables
var bottlesScene: PackedScene
# var terminalScene: PackedScene = preload(

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
	# list of all entities in a section
	var entitiesToSpawn = entityData.split("~~~~~")
	
	# required data pieces for entity spawning
	var entityType: String
	var entityId: String
	var direction: String
	var spawnCoordinatesString: String
	var spawnCoordinatesVector: Vector2i
	
	# variable to hold additional data, if the entity has any
	var otherData: String
	
	# dictionaries to save additional entity data in for later
	var enemyNodes: Dictionary = {}
	var interactablesTextbox: Dictionary = {}
	for i in entitiesToSpawn:
		i = i.strip_edges()
		var parts: Array = i.split(":")
		var spawnData = parts[0].split(";")
		entityType = spawnData[0].strip_edges()
		entityId = spawnData[1].strip_edges()
		direction = spawnData[2].strip_edges()
		spawnCoordinatesString = spawnData[3].strip_edges()
		# checks if there's only the four required data pieces
		if parts.size() > 1:
			# sets otherData to additional data
			otherData = parts[1].strip_edges()
		else:
			# marks otherData as nothing
			otherData = "none"
		
		# takes additional data from spawnCoordinates if it's an enemy node
		# then sets spawnCoordinates to just the coordinates part of the node
		# the rest is saved under the node's id (always P0 initially) and _Inst
		if entityGroup == "enemy":
			var nodeData = spawnCoordinatesString.split("/")
			for n in nodeData:
				nodeData[nodeData.index[n]] = n.strip_edges()
			enemyNodes["P0_Inst"] = nodeData[2]
			spawnCoordinatesString = nodeData[1]
		
		# converts spawnCoordinates from a String to a Vector2i
		for c in spawnCoordinatesString:
			if c == "(" or c == ")" or c == " ":
				spawnCoordinatesString.replace(c, "")
				# turns spawncoordinates into two number strings
				var coordXY = spawnCoordinatesString.split(",")
				# converts number strings to int and then creates a Vector2i with them
				var coordinates = Vector2i(int(coordXY[0]), int(coordXY[1]))
				if entityGroup == "enemies":
					enemyNodes["P0"] = coordinates
				spawnCoordinatesVector = coordinates
		
		# spawns entities, gives them id, direction, and position
		var sceneToInstantiate = entityScenes[entityType]
		var entity = sceneToInstantiate.instantiate()
		entity.id = entityId
		entity.direction = direction
		entity.global_position = physicsMap.map_to_local(spawnCoordinatesVector)
		
		# if an entity is an enemy, checks for a node list
		# if there is a node list, saves all node information in enemyNodes
		# sets the enemy's nodes dictionary in enemy to enemyNodes
		if entityGroup == "enemies":
			if otherData != "none":
				for o in otherData.split(";"):
					var nodeParts = o.split("/")
					var coordinates: Vector2i
					for n in nodeParts:
						nodeParts[nodeParts.index[n]] = n.strip_edges()
					for a in nodeParts[1]:
						if a == "(" or a == ")" or a == " ":
							nodeParts[1].replace(a, "")
							# turns spawncoordinates into two number strings
							var coordXY = nodeParts[1].split(",")
							# converts number strings to int and then creates a Vector2i with them
							coordinates = Vector2i(int(coordXY[0]), int(coordXY[1]))
					enemyNodes[nodeParts[0]] = coordinates
					enemyNodes[nodeParts[0] + "_Inst"] = nodeParts[2]
				entity.nodes = enemyNodes
		
		# if an entity is an interactable, checks for textlines
		# if there are textlines, saves all textline information in interactablesTextbox
		# sets the interactable's textbox dictionary to interactablesTextbox
		elif entityGroup == "interactables":
			if otherData != "none":
				for o in otherData.split(";"):
					var lineParts = o.split("/")
					for l in lineParts:
						lineParts[lineParts.index[l]] = l.strip_edges()
					interactablesTextbox[lineParts[0]] = lineParts[2]
					interactablesTextbox[lineParts[0] + "_Sprite"] = lineParts[1]
				entity.textbox = interactablesTextbox
		
		# adds entity to scene under entityList once all data is done being set
		entityList.add_child(entity)

func _map_loaded(map):
	# map is either "physics", "visuals" or "vents"
	loaded[map] = true

# await get_tree().create_timer(10).timeout
