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

# var entityInfo: Dictionary = {}
# don't know if I need this anymore?

func _ready():
	var levelData = FileAccess.open("res://Level" + str(levelId), FileAccess.READ)
	levelData = levelData.get_as_text()
	levelData = levelData.split("=====")
	
	# make sure that the numbers are updated when adding more parts before other parts
	
	# load settings
	# skipped for now
	
	# load physicsTilemap
	physics.emit(levelData[0])
	
	# load player
	loadEntities(levelData[1], "player")
	
	# load enemies
	loadEntities(levelData[2], "enemies")

func loadEntities(entityData, entityGroup):
	# spawns entity based on entityType
	# saves instance in entityInfo for later if needed
	# sets direction and position on tilemap after splitting on ", "
	for i in entityData.split("~~~~~"):
		var entityElements = entityData.split(";")
		for e in entityElements:
			e = e.strip_edges()
		var entityType = entityElements[0]
		if entityGroup == "player":
			var entityId = entityElements[1]
			var player = PlayerScene.instantiate()
			for p in entityElements[2]:
				if p == "(" or p == ")":
					p.replace(p, "")
			var spawnInfo = entityElements[2].split(", ")
			for s in spawnInfo:
				s = s.strip_edges()
			player.direction = spawnInfo[0]
			player.global_position = physicsMap.map_to_local(Vector2i(spawnInfo[1], spawnInfo[2]))
			entityList.add_child(player)
			
		elif entityGroup == "enemies":
			var enemy
			var enemyNodes: Dictionary = {}
			if entityType == "Guard":
				enemy = GuardScene.instantiate()
			else:
				# will add other enemy types here later
				pass
			var enemyParts = entityElements[1].split(":")
			var entityId = enemyParts[0]
			var nodes = enemyParts[1].split(";")
			for n in nodes:
				n = n.strip_edges()
			for node in nodes:
				var nodeElements = node.split("/")
				enemyNodes[nodeElements[0] + "Coords"] = nodeElements[1]
				enemyNodes[nodeElements[0] + "Commands"] = nodeElements[2]
				# make sure to have enemy code check dictionary size
			for c in enemyNodes["P0Coords"]:
				if c == "(" or c == ")" or c == " ":
					c.replace(c, "")
			var xyNums = enemyNodes["P0Coords"].split(",")
			enemy.global_position = Vector2i(int(xyNums[0]), int(xyNums[1]))
			enemy.direction = enemyNodes["P0Commands"]
			enemy.nodes = enemyNodes
