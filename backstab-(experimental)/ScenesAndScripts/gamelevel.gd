extends Node2D

signal connectToPlayer
signal instructionsFilled

var sniperScene: PackedScene = preload("res://ScenesAndScripts/Sniper.tscn")
var playerScene: PackedScene = preload("res://ScenesAndScripts/Player.tscn")

var enemyInfo: Dictionary = {}
var sniperNum = 0

func _ready():
	loadMap(FileAccess.open("res://MapFiles/EntityMap1.txt", FileAccess.READ))
	loadInstructions(FileAccess.open("res://Mapfiles/EnemyInstructions1.txt", FileAccess.READ))
	enemyInfo["isWorking"] = "testvalue"

func loadMap(entityMap):
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
		var instructions = parts[2]
		enemyInfo["InitFacing" + enemyID] = initialFacing
		enemyInfo["Instructions" + enemyID] = instructions
	instructionsFilled.emit()
