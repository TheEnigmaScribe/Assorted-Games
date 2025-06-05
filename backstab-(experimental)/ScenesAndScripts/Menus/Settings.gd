extends Control

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/MainMenu.tscn")

func _on_controls_pressed() -> void:
	pass # Replace with function body.

func _on_visuals_pressed():
	# go to visuals menu
	pass


func _on_audio_pressed():
	# go to audio menu
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/MainMenu.tscn")

func _on_title_pressed():
	$VineBoom.play()
