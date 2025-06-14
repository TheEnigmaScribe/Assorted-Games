extends TileMapLayer

signal mapLoaded

# textureId lines up with tileset id's in the node itself, change for different tileset
# add textures to tilemaplayer for other tilesets
# 0 refers to TestTiles
var textureId: int = 0

func _on_game_level_visuals(map):
	var mapData = map
	var xCoord: int = -1
	# yCoord is -2 because it double triggers initially for some reason
	var yCoord: int = -2
	var tileLocation: Vector2i
	print(get_used_cells())
	for line in mapData.split("\n"):
		line.strip_edges()
		yCoord += 1
		xCoord = -1
		for i in line:
			xCoord += 1
			print("(" + str(xCoord) + ", " + str(yCoord) + ") = " + i)
			if i == "L": # wall
				tileLocation = Vector2i(0, 3)
			elif i == "M":
				tileLocation = Vector2i(1, 3)
			elif i == "R":
				tileLocation = Vector2i(2, 3)
			elif i == "T":
				tileLocation = Vector2i(1, 1)
			elif i == "F":
				tileLocation = Vector2i(5, 0)
			elif i == "1":
				tileLocation = Vector2i(0, 0)
			elif i == "2":
				tileLocation = Vector2i(1, 0)
			elif i == "3":
				tileLocation = Vector2i(2, 0)
			elif i == "4":
				tileLocation = Vector2i(0, 1)
			elif i == "5":
				tileLocation = Vector2i(2, 1)
			elif i == "6":
				tileLocation = Vector2i(0, 2)
			elif i == "7":
				tileLocation = Vector2i(1, 2)
			elif i == "8":
				tileLocation = Vector2i(2, 2)
			elif i == "-":
				tileLocation = Vector2i(4, 2)
			else:
				continue
			# coordinates for placement, and coordinates on atlasTexture of tile to place
			await tileLocation != null
			set_cell(Vector2i(xCoord, yCoord), textureId, tileLocation)
	mapLoaded.emit("visuals")
