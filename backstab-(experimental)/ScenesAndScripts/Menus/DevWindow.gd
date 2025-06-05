extends Control

signal folderPath(stringname: String)

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/MainMenu.tscn")

func _on_test_level_pressed():
	folderPath.emit("res://MapFiles/TestMap")
	get_tree().change_scene_to_file("res://ScenesAndScripts/Gamelevel/Gamelevel.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/MainMenu.tscn")
