extends TileMapLayer

signal ventsDone


func _on_gamelevel_load_vents(mapdata: String):
	ventsDone.emit("vents")
