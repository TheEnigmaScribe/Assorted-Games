extends Node

var Main: PackedScene = preload("res://Menus/Main.tscn")
var Level: PackedScene = preload("res://Level/Level.tscn")
var Restart: PackedScene = preload("res://Menus/Restart.tscn")
var Continue: PackedScene = preload("res://Menus/Continue.tscn")

func _ready():
	var menu = Main.instantiate()
	add_child(menu)
	menu.connect("changeScene", _on_change_scene)

func _on_change_scene(sceneName, levelId):
	var oldScene = get_child(0)
	var newScene: PackedScene
	if sceneName == "Main":
		newScene = Main
	elif sceneName == "Level":
		newScene = Level
	elif sceneName == "Restart":
		newScene = Restart
	elif sceneName == "Continue":
		newScene = Continue
	var scene = newScene.instantiate()
	if sceneName == "Level":
		newScene.levelId = levelId
	scene.connect("changeScene", _on_change_scene)
	add_child(scene)
	oldScene.queue_free()
	
