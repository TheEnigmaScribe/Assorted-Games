extends Control
# at some point add a feature that checks whether or not the player has played before or not
# that way the save can display start or continue, depending on which

signal levelID

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/StoryOrSelection.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/StoryOrSelection.tscn")
