extends Control

# try to get rid of button activated box? 
# or perhaps make an animated selection thing around boxes instead
# add animation transitions when going into a level
var code: String = ">"

func _process(_delta):
	typing()
	if Input.is_action_just_pressed("enter"):
		if code == ">silence":
			openDevWindow()

func _on_play_pressed():
	# bring up story or level selection options
	# story has you go through the levels in order, with the only option being going to the next level
	# also display stats and what level you're on on story save
	# level selection allows you to select any level you've played, plus some bonus levels
	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/StoryOrSelection.tscn")

func _on_settings_pressed():
	# controls, keyboard only after all
	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/Settings.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_title_pressed():
	$VineBoom.play()

func openDevWindow():
	get_tree().change_scene_to_file("res://ScenesAndScripts/Menus/DevWindow.tscn")

func typing():
	if Input.is_action_just_pressed("a"):
		code += "a"
	elif Input.is_action_just_pressed("b"):
		code += "b"
	elif Input.is_action_just_pressed("c"):
		code += "c"
	elif Input.is_action_just_pressed("d"):
		code += "d"
	elif Input.is_action_just_pressed("e"):
		code += "e"
	elif Input.is_action_just_pressed("f"):
		code += "f"
	elif Input.is_action_just_pressed("g"):
		code += "g"
	elif Input.is_action_just_pressed("h"):
		code += "h"
	elif Input.is_action_just_pressed("i"):
		code += "i"
	elif Input.is_action_just_pressed("j"):
		code += "j"
	elif Input.is_action_just_pressed("k"):
		code += "k"
	elif Input.is_action_just_pressed("l"):
		code += "l"
	elif Input.is_action_just_pressed("m"):
		code += "m"
	elif Input.is_action_just_pressed("n"):
		code += "n"
	elif Input.is_action_just_pressed("o"):
		code += "o"
	elif Input.is_action_just_pressed("p"):
		code += "p"
	elif Input.is_action_just_pressed("q"):
		code += "q"
	elif Input.is_action_just_pressed("r"):
		code += "r"
	elif Input.is_action_just_pressed("s"):
		code += "s"
	elif Input.is_action_just_pressed("t"):
		code += "t"
	elif Input.is_action_just_pressed("u"):
		code += "u"
	elif Input.is_action_just_pressed("v"):
		code += "v"
	elif Input.is_action_just_pressed("w"):
		code += "w"
	elif Input.is_action_just_pressed("x"):
		code += "x"
	elif Input.is_action_just_pressed("y"):
		code += "y"
	elif Input.is_action_just_pressed("z"):
		code += "z"
	elif Input.is_action_just_pressed("space"):
		code += " "
	elif Input.is_action_just_pressed("."):
		code += "."
	elif Input.is_key_pressed(KEY_BACKSPACE):
		code = code.substr(0, code.length() - 1)
	if code == "":
		code = ">"

func _on_devwindowtemp_pressed() -> void:
	openDevWindow()
