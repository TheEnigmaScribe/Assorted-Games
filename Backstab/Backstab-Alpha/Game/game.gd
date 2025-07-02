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
	var newScene #possibly later make it specifically packedScene or node?
	if sceneName == "Main":
		newScene = Main.instantiate()
	elif sceneName == "Level":
		newScene = Level.instantiate()
	elif sceneName == "Restart":
		newScene = Restart.instantiate()
	elif sceneName == "Continue":
		newScene = Continue.instantiate()
	# var scene = newScene
	if sceneName == "Level":
		newScene.levelId = levelId
	newScene.connect("changeScene", _on_change_scene)
	add_child(newScene)
	oldScene.queue_free()
	
