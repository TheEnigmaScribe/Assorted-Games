extends Control

signal levelID

# have ten levels displayed at a time, with the ability to change "windows" to access other sets

# keeps track of what page of levels the player is on, as each set is a different area
var whatPage: int

# also figure out displaying if a level is locked, not complete or complete
# needs to vary by page too

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/StoryOrSelection.tscn")

# button pressed method
func _load_level(id: int, unlocked: bool):
	if unlocked == false:
		# do the "locked" animation, or otherwise inform the player
		pass
	elif unlocked == true:
		# play animation
		# load the level, using the id as an argument
		pass

# also consider displaying more information about the level too somewhere
func _on_back_pressed():
	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/StoryOrSelection.tscn")

func _on_title_pressed():
	$VineBoom.play()
