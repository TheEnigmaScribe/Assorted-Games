extends Control

signal changeScene

# not necessary for now, but in the future will save data about what the player has done
# mostly statistics and whether or not a level is complete
# the latter is for displaying a "completed" icon or not, as well as where to continue
var playerData = FileAccess.open("res://player_data", FileAccess.READ)

func _on_control_pressed(button):
	if button == "Start":
		# later make it go to first level or next level based on playerData
		pass
	elif button == "Quit":
		get_tree().quit()

func _on_level_pressed(levelId):
	changeScene.emit("Level", levelId)
