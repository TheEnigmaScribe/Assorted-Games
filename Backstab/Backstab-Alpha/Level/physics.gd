extends TileMapLayer


func _on_level_physics(tileData):
	for row in tileData.split("\n"):
		for tile in row:
			pass
