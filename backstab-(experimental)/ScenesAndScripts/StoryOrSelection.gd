extends Control


func _on_campaign_pressed():
	# go to saved level? have a second menu in this that displays stats, including time, level, etc
	# also deaths
	# then have a continue button in there too
	get_tree().change_scene_to_file("res://ScenesAndScripts/Campaign.tscn")


func _on_levels_pressed() -> void:
	get_tree().change_scene_to_file("res://ScenesAndScripts/LevelSelection.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://ScenesAndScripts/MainMenu.tscn")


func _on_title_pressed():
	$VineBoom.play()
