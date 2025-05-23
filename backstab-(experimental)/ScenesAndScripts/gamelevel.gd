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
	#print(enemyMapData)
	enemyMap.close()
	var xCoord = 0
	var yCoord = 0
	for line in enemyMapData:
		for i in line:
			xCoord += 1
			#print(xCoord)
			#print(i)
			if i == "/":
				xCoord = 0
				yCoord += 1
			elif i == "[" or i == "]":
				xCoord -= 1
			elif i == "#":
				pass
			elif i == "S":
				var sniper = sniperScene.instantiate()
				print(str(xCoord) + ", " + str(yCoord))
				sniper.position = Vector2(((xCoord - 1) * 32) + 16, (yCoord * 32) + 16)
				# temp note- intended spawn should be tile 7, 2
				add_child(sniper)
				var enemyID = "S" + str(sniperNum)
				enemyDict[enemyID] = sniper
				print(enemyID)
				enemyList[enemyNum] = "S" + str(sniperNum)
				sniperNum += 1
				enemyNum += 1
				loadInstructions(enemyInstructions, enemyID)
				#sniper.instructions = enemyInst[enemyID]
			else:
				xCoord -= 1

func loadInstructions(enemyInstructions, enemyID):
	var stop: bool = false
	if enemyInstructions == null:
		print("failed to load enemyInstructions")
	else:
		print("enemyInstructions loaded")
	var enemyInstructionsData = enemyInstructions.get_as_text()
	for line in enemyInstructionsData:
		if enemyInstructionsData.substr(0, 2) == "[]":
			stop = true
		elif stop != true:
			if enemyDict[enemyInstructionsData.substr(0, 2)] == null:
				print("enemyID in instructions not valid")
				pass
			if enemyInstructionsData.substr(0, 2) == enemyID:
				var instructions: String = line
				print(line)
				instructions.replace(instructions.substr(0,3),"")
				print(instructions)
				enemyInst[enemyID] = instructions
				#print(enemyInst[enemyID])
				return enemyInst[enemyID]
		if (stop == true) and enemyDict[enemyID] != null:
			print("Failed to load " + enemyID + ", loading default behavior.")
			var defaultBehavior = "LLLL"
			enemyInst[enemyID] = defaultBehavior
			pass
