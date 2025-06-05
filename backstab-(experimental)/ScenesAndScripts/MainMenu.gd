extends Control

# try to get rid of button activated box? 
# or perhaps make an animated selection thing around boxes instead
# add animation transitions when going into a level

func _on_play_pressed():
	# bring up story or level selection options
	# story has you go through the levels in order, with the only option being going to the next level
	# also display stats and what level you're on on story save
	# level selection allows you to select any level you've played, plus some bonus levels
	get_tree().change_scene_to_file("res://ScenesAndScripts/StoryOrSelection.tscn")


func _on_settings_pressed():
	# controls, keyboard only after all
	get_tree().change_scene_to_file("res://ScenesAndScripts/Settings.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_title_pressed():
	$VineBoom.play()
