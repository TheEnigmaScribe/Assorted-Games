extends Node2D

var sniperScene: PackedScene = preload("res://ScenesAndScripts/Sniper.tscn")

var enemyList = {}
var enemyDict = {}
var enemyInst = {}
var enemyLoad = {}
var enemyNum = 0
var sniperNum = 0

func _ready():
	var enemyMap = FileAccess.open("res://MapFiles/EnemyMap1.txt", FileAccess.READ)
	var enemyInstructions = FileAccess.open("res://Mapfiles/EnemyInstructions1.txt", FileAccess.READ)
	loadMap(enemyMap, enemyInstructions)
	
func loadMap(enemyMap, enemyInstructions):
	if enemyMap == null:
		print("failed to load enemyMap")
	else:
		print("enemyMap loaded")
	var enemyMapData = enemyMap.get_as_text()
	enemyMap.close()
	for line in enemyMapData:
		for i in enemyMapData:
			if "S":
				var sniper = sniperScene.instantiate()
				add_child(sniper)
				var enemyID = "S" + str(sniperNum)
				enemyDict[enemyID] = sniper
				print(enemyID)
				enemyList[enemyNum] = "S" + str(sniperNum)
				sniperNum += 1
				enemyNum += 1
				loadInstructions(enemyInstructions, enemyID)
				sniper.instructions = enemyInst[enemyID]
			else:
				pass

func loadInstructions(enemyInstructions, enemyID):
	var finish: bool = false
	if enemyInstructions == null:
		print("failed to load enemyInstructions")
	else:
		print("enemyInstructions loaded")
	var enemyInstructionsData = enemyInstructions.get_as_text()
	for line in enemyInstructionsData:
		if enemyInstructionsData.substr(0, 2) == "[]":
			finish = true
		elif finish != true:
			if enemyDict[enemyInstructionsData.substr(0, 2)] == null:
				print("enemyID in instructions not valid")
				pass
			if enemyInstructionsData.substr(0, 2) == enemyID:
				var instructions: String
				for i in line:
					if i == "M":
						instructions + "M"
					elif i == "L":
						instructions + "L"
					elif i == "R":
						instructions + "R"
					elif i == "U":
						instructions + "U"
					elif i == "H":
						instructions + "H"
				enemyInst[enemyID] = instructions
				enemyLoad[enemyID] = true
				return enemyInst[enemyID]
		if (finish == true) and enemyDict[enemyID] != null:
			print("Failed to load " + enemyID + ", loading default behavior.")
			var defaultBehavior = "LLLL"
			enemyInst[enemyID] = defaultBehavior
			pass
