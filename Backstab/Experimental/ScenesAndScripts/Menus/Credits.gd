extends Control

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/StoryOrSelection.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/StoryOrSelection.tscn")
