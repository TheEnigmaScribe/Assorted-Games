extends TileMapLayer

signal loaded

var textureId = 0
# changes which tileset I'm using

func _on_level_physics(tileData):
	var map = tileData
	var xCoord: int = -2
	# yCoord is -2 because it double triggers initially for some reason
	var yCoord: int = -1
	var tileLocation: Vector2i
	for row in map.split("\n"):
		row = row.strip_edges()
		yCoord += 1
		xCoord = -1
		# new row so x coordinate should start back at 0
		for tile in row:
			xCoord += 1
			# print("(" + str(xCoord) + ", " + str(yCoord) + ") = " + i)
			if tile == "-":
				tileLocation = Vector2i(0, 0)
				print("spawned floor tile at " + str(xCoord) + ", " + str(yCoord))
			elif tile == "#":
				print("spawned wall tile at " + str(xCoord) + ", " + str(yCoord))
				tileLocation = Vector2i(1, 0)
			elif tile == "G":
				print("spawned goal tile at " + str(xCoord) + ", " + str(yCoord))
				tileLocation = Vector2i(2, 0)
			set_cell(Vector2i(xCoord, yCoord), textureId, tileLocation)
		loaded.emit("physics")
