extends Control

signal levelID(stringname: String)
signal changeScene

func _ready():
	pass

func _process(_delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/MainMenu.tscn")

func _on_test_level_pressed():
	# given level naming conventions, probably just directly provide the level path?
	changeScene.emit("level", "Test")
	# levelID.emit("Test")
	# get_tree().change_scene_to_file("res://ScenesAndScripts/Gamelevel/Gamelevel.tscn")


#func _on_back_pressed() -> void:
#	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/MainMenu.tscn")
