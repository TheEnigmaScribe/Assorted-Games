extends TileMapLayer

signal visualsDone

func _on_gamelevel_load_visuals(mapdata: String):
	visualsDone.emit("visuals")
