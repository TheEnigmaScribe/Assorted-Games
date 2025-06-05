extends Node2D

signal pathReceived
signal connectToPlayer
signal connectToEnemies
signal instructionsFilled
signal gameOver
signal levelComplete

var folderPath: String
var mapLoaded: bool = false
var sniperScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Sniper.tscn")
var playerScene: PackedScene = preload("res://ScenesAndScripts/LevelElements/Player.tscn")
var levelFilePath: String
var firstTrigger: bool = false
var secondFillCheck: bool = false

var enemyInfo: Dictionary = {}
var sniperNum = 0

func _ready():
	Global.returnedFolderPath.connect(_load_level)
	# print(folderPath)
	# loadMap(FileAccess.open("res://MapFiles/EntityMap1.txt", FileAccess.READ))
	# loadInstructions(FileAccess.open("res://Mapfiles/EnemyInstructions1.txt", FileAccess.READ))
	# enemyInfo["isWorking"] = "testvalue"
	pass

func _load_level(folderPath):
	if firstTrigger == true:
		return
	firstTrigger = true
	levelFilePath = folderPath
	# print(levelFilePath)
	pathReceived.emit()
	var entityMap: String
	var enemyInstructions: String
	var dir := DirAccess.open(levelFilePath)
	# dir is a useless string here
	if dir == null:
		print("Could not open folder " + levelFilePath + ".")
	dir.list_dir_begin()
	print(dir.get_files())
	# gets file array stuff
	for file: String in dir.get_files():
		var resource = file
		var fileNameParts: Array = resource.split("_")
		if fileNameParts[0] == "EntityMap":
			print("Attempting to load " + resource + " for EntityMap.")
			loadEntities(FileAccess.open(levelFilePath + "/" + resource, FileAccess.READ))
			#print("loading entitymap")
		elif fileNameParts[0] == "EnemyInstructions":
			print("Attempting to load " + resource + " for EnemyInstructions.")
			loadInstructions(FileAccess.open(levelFilePath + "/" + resource, FileAccess.READ))
			#print("loading enemyInstructions")

func _process(delta):
	if secondFillCheck == false:
		for i in 10:
			if i == 9:
				instructionsFilled.emit()
				secondFillCheck = true
	if mapLoaded == false:
		return
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		get_tree().paused = true
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		get_tree().paused = false

func loadEntities(entityMap):
	# load entityMap
	var entityMapData = entityMap.get_as_text()
	#print(entityMapData)
	entityMap.close()
	var xCoord = -1
	var yCoord = 0
	for line in entityMapData:
		for i in line:
			xCoord += 1
			if i == "\n":
				yCoord += 1
				xCoord = -1
			elif i == "P":
				var player = playerScene.instantiate()
				$EntityList.add_child(player)
				player.position = Vector2((xCoord * 32) + 16, (yCoord * 32) + 16)
			elif i == "S":
				var enemyID = "S" + str(sniperNum) 
				var sniper = sniperScene.instantiate()
				sniper.position = Vector2((xCoord * 32) + 16, (yCoord * 32) + 16)
				$EntityList.add_child(sniper)
				sniper.name = enemyID
				# enemyInfo stores all enemy info, though in seperate entries
				# each entry is the appropriate string and then the enemy ID
				enemyInfo["Instance" + enemyID] = sniper
				sniper.instPath = sniper
				sniper.id = enemyID
				sniper.add_to_group("enemies")
				# print("sniper.id is " + sniper.id)
				sniperNum += 1
			elif i == "X":
				connectToPlayer.emit()
				connectToEnemies.emit()
				for e in get_tree().get_nodes_in_group("enemies"):
					e.playerSeen.connect(_game_over)
				for p in get_tree().get_nodes_in_group("player"):
					if p is Sprite2D:
						p.reachedGoal.connect(_level_complete)

func loadInstructions(enemyInstructions):
	# load enemyInstructions
	var enemyInstructionsData = enemyInstructions.get_as_text()
	for line in enemyInstructionsData.split("\n"):
		line = line.strip_edges()
		var parts = line.split(" ")
		if line.is_empty():
			continue
		var enemyID = parts[0]
		var initialFacing = parts[1]
		var instructions: String
		if parts.size() == 2:
			instructions = "null"
		else: 
			instructions = parts[2]
		enemyInfo["InitFacing" + enemyID] = initialFacing
		enemyInfo["Instructions" + enemyID] = instructions
	instructionsFilled.emit()
	print("instructionsFilled emitted")

func _game_over():
	print("gameOver")
	gameOver.emit()

func _level_complete():
	# level ending sequence probably has player walking off through the exit to elsewhere
	# enemies possibly relax or something like that, but not necessarily
	# things like snipers bringing up their guns and pointing em up as if done
	print("level completed")
	levelComplete.emit()

# possible thing to implement
func _go_on_alert():
	pass
