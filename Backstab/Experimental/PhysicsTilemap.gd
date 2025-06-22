extends TileMapLayer

signal physicsDone

func _on_gamelevel_load_physics(mapdata: String):
	physicsDone.emit("physics")
