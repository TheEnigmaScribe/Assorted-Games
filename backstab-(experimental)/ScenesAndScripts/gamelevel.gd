extends Node2D

var sniperScene: PackedScene = preload("res://ScenesAndScripts/Sniper.tscn")

var enemyDict = {}
var enemyInst = {}
var enemyNum = 0
var sniperNum = 0

func _ready():
	loadMap(FileAccess.open("res://MapFiles/EnemyMap1.txt", FileAccess.READ))
	loadInstructions(FileAccess.open("res://Mapfiles/EnemyInstructions1.txt", FileAccess.READ))
	print(enemyInst["S0"])

func loadMap(enemyMap):
	if enemyMap == null:
		print("failed to load enemyMap")
	else:
		print("enemyMap loaded")
	var enemyMapData = enemyMap.get_as_text()
	#print(enemyMapData)
	enemyMap.close()
	var xCoord = 0
	var yCoord = 0
	for line in enemyMapData:
		for i in line:
			xCoord += 1
			if i == "\n":
				yCoord += 1
				xCoord = 0
			elif i == "S":
				var sniper = sniperScene.instantiate()
				print(str(xCoord) + ", " + str(yCoord))
				sniper.position = Vector2(((xCoord - 1) * 32) + 16, (yCoord * 32) + 16)
				# temp note- intended spawn should be tile 7, 2
				add_child(sniper)
				var enemyID = "S" + str(sniperNum)
				enemyDict[enemyID] = sniper
				print(enemyID)
				sniperNum += 1
				enemyNum += 1
				sniper.id = enemyID

func loadInstructions(enemyInstructions):
	if enemyInstructions == null:
		print("failed to load enemyInstructions")
	else:
		print("enemyInstructions loaded")
	var enemyInstructionsData = enemyInstructions.get_as_text()
	for line in enemyInstructionsData.split("\n"):
		line = line.strip_edges()
		var parts = line.split(" ")
		if line.is_empty():
			continue
		var enemyID = parts[0]
		var instructions = parts[1]
		enemyInst[enemyID] = instructions
		
