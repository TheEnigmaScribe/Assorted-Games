extends Control
# at some point add a feature that checks whether or not the player has played before or not
# that way the save can display start or continue, depending on which

func _on_back_pressed():
	get_tree().change_scene_to_file("res://ScenesAndScripts/StoryOrSelection.tscn")
