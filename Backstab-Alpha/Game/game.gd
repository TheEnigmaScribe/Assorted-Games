extends Node

var Main: PackedScene = preload("res://Menus/Main.tscn")
var Level: PackedScene
var Restart: PackedScene = preload("res://Menus/Restart.tscn")
var Continue: PackedScene = preload("res://Menus/Continue.tscn")
var Escape: PackedScene = preload("res://Menus/Escape.tscn")

func _ready():
	var menu = Main.instantiate()
	add_child(menu)
	menu.connect("changeScene", _on_change_scene)

	#if Input.is_action_just_pressed("escape"):
	#	if get_child(0) == Main:
	#		return
	#	elif get_child_count() > 1:
	#		if get_child(1) == Escape:
	#			if Input.is_action_just_pressed("escape"):
	#				get_child(1).queue_free()
	#	else:
	#		var escapeMenu = Escape.instantiate()
	#		add_child(escapeMenu)
	#		escapeMenu.connect("changeScene", _on_change_scene)

func _on_change_scene(sceneName, otherData):
	var oldScene = get_child(0)
	var newScene #possibly later make it specifically packedScene or node?
	if otherData == "Escape":
		get_child(1).queue_free()
		get_tree().paused = false
	if sceneName == "Main":
		newScene = Main.instantiate()
	elif sceneName == "Level":
		Level = load("res://Levels/Level_" + otherData + ".tscn")
		newScene = Level.instantiate()
	elif sceneName == "Restart":
		newScene = Restart.instantiate()
	elif sceneName == "Continue":
		newScene = Continue.instantiate()
	# var scene = newScene
	newScene.connect("changeScene", _on_change_scene)
	if sceneName == "Restart" or sceneName == "Continue":
		newScene.connect("escapeMenu", _on_menu_escape)
	elif sceneName == "Level":
		newScene.connect("escapeMenu", _on_level_escape)
	add_child(newScene)
	oldScene.queue_free()

func _on_menu_escape(menu):
	if menu == "Restart" or menu == "Continue":
		# play whatever menu transition
		_on_change_scene("Main", "none")
	#elif menu == "Audio" or menu == "Visuals" or menu == "Misc":
	#	_on_change_scene("Settings", "none")

func _on_level_escape():
	var escapeMenu = Escape.instantiate()
	get_tree().paused = true
	add_child(escapeMenu)
	escapeMenu.connect("changeScene", _on_change_scene)
