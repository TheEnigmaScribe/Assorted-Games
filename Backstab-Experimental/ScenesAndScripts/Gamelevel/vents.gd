extends TileMapLayer

signal mapLoaded

# textureId lines up with tileset id's in the node itself, change for different tileset
# add textures to tilemaplayer for other tilesets
# 0 refers to TestTiles
var textureId: int = 0

func _on_game_level_vents(map):
	mapLoaded.emit("vents")
