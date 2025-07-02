extends Node2D

# signals
signal changeScene
signal physics

@onready var physicsMap = $Physics
@onready var entityList = $EntityList

# preloaded scenes
var PlayerScene: PackedScene = preload("res://Entities/Player/Player.tscn")
var GuardScene: PackedScene = preload("res://Entities/Guard/Guard.tscn")

var levelId: int

var loadedList: Dictionary = {"physics": false}
# var entityInfo: Dictionary = {}
# don't know if I need this anymore?

func _ready():
	var levelData = FileAccess.open("res://Maps/Level" + str(levelId) + ".txt", FileAccess.READ)
	levelData = levelData.get_as_text()
	levelData = levelData.split("=====")
	
	# make sure that the numbers are updated when adding more parts before other parts
	
	# load settings
	# skipped for now
	
	# load physicsTilemap
	physics.emit(levelData[0])
	await loadedList["physics"] == true
	
	# load player
	loadEntities(levelData[1], "player")
	
	# load enemies
	loadEntities(levelData[2], "enemies")

func loadEntities(entityData, entityGroup):
	# spawns entity based on entityType
	# saves instance in entityInfo for later if needed
	# sets direction and position on tilemap after splitting on ", "
	for i in entityData.split("~~~~~"):
		var entityElements: Array = entityData.split(";")
		for index in entityElements.size():
			entityElements[index - 1] = entityElements[index - 1].strip_edges()
		var entityType = entityElements[0]
		if entityGroup == "player":
			var entityId = entityElements[1]
			var player = PlayerScene.instantiate()
			for p in entityElements[2]:
				if p == "(" or p == ")":
					entityElements[2] = entityElements[2].replace(p, "")
			var spawnInfo = entityElements[2].split(", ")
			for part in spawnInfo.size():
				spawnInfo[part - 1] = spawnInfo[part - 1].strip_edges()
			player.direction = spawnInfo[0]
			player.global_position = physicsMap.map_to_local(Vector2i(int(spawnInfo[1]), int(spawnInfo[2])))
			entityList.add_child(player)
			
		elif entityGroup == "enemies":
			var enemy
			var enemyNodes: Dictionary = {}
			if entityType == "guard":
				enemy = GuardScene.instantiate()
			else:
				# will add other enemy types here later
				pass
			var enemyParts = entityElements[1].split(":")
			var entityId = enemyParts[0]
			var nodes = enemyParts[1].split(";")
			for n in nodes.size():
				nodes[n - 1] = nodes[n - 1].strip_edges()
			for node in nodes:
				var nodeElements = node.split("/")
				enemyNodes[nodeElements[0] + "Coords"] = nodeElements[1]
				enemyNodes[nodeElements[0] + "Commands"] = nodeElements[2]
				# make sure to have enemy code check dictionary size
			for char in enemyNodes["P0Coords"]:
				if char == "(" or char == ")" or char == " ":
					enemyNodes["P0Coords"] = enemyNodes["P0Coords"].replace(char, "")
			var xyNums = enemyNodes["P0Coords"].split(",")
			enemy.global_position = physicsMap.map_to_local(Vector2i(int(xyNums[0]), int(xyNums[1])))
			enemy.direction = enemyNodes["P0Commands"]
			enemy.nodes = enemyNodes
			entityList.add_child(enemy)

func _loaded(loadedObject):
	if loadedObject == "physics":
		loadedList["physics"] == true
