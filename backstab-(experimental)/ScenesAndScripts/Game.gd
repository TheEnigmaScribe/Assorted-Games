extends Node

# menus
var mainMenu: PackedScene = preload("res://ScenesAndScripts/Menus/MainMenu.tscn")
var devMenu: PackedScene = preload("res://ScenesAndScripts/Menus/DevWindow.tscn")
var selectionMenu: PackedScene = preload("res://ScenesAndScripts/Menus/LevelSelection.tscn")
var campaignMenu: PackedScene = preload("res://ScenesAndScripts/Menus/Campaign.tscn")
var levelMenu: PackedScene = preload("res://ScenesAndScripts/Menus/LevelSelection.tscn")
var settingsMenu: PackedScene = preload("res://ScenesAndScripts/Menus/Settings.tscn")
var creditsMenu: PackedScene = preload("res://ScenesAndScripts/Menus/Credits.tscn")

# gamelevel, which then preloads the game elements itself
var gamelevel: PackedScene = preload("res://ScenesAndScripts/Gamelevel/Gamelevel.tscn")

func _ready():
	# creates main menu as a child (temporarily dev menu)
	var dev = devMenu.instantiate()
	add_child(dev)
	# var main = mainMenu.instantiate()
	# add_child(main)

#signal returnedLevelPath(string: String)

func _process(delta):
	# checks if it's already connected to the changeScene signal for the current "main" scene
	if get_child(0).is_connected("changeScene", _change_scene) == false:
		get_child(0).connect("changeScene", _change_scene)

func _change_scene(newScene, sceneFile):
	if newScene == "level":
		# loads gamelevel, sents the variable that contains the file path to the level file path
		# adds gamelevel to tree, removes and then frees the old scene
		var level = gamelevel.instantiate()
		level.levelFilePath = "res://MapFiles/Maps/Level_" + sceneFile + ".txt"
		var sceneToRemove = get_child(0)
		add_child(level)
		remove_child(sceneToRemove)
		sceneToRemove.queue_free()
	if newScene == "menu":
		# adds sceneFile with "Menu" in order to get a menu variable name
		# then uses get() to get said menu variable
		# adds menu to the tree, removes and then frees old scene
		var menu = get(sceneFile + "Menu")
		var sceneToRemove = get_child(0)
		add_child(menu)
		remove_child(sceneToRemove)
		sceneToRemove.queue_free()

#var path: String
#var levelID: String
#var fileToReturn: bool = false
#var connectedToGameLevel = false
#var checkedInitially: bool = false

#func _process(_delta):
#	var scene = get_tree().current_scene
#	var currentScene: Array = str(get_tree().current_scene).split(":")
#	var sceneName: String = currentScene[0]
#	var lastSceneName: String
	# connect to scene if scene can load level
	# additional code is solely so I don't get 500 errors within the next few seconds
#	if sceneName == "DevWindow" or sceneName == "LevelSelection" or sceneName == "Campaign":
#		if checkedInitially != true:
#			scene.levelID.connect(_return_file)
#			checkedInitially = true
#		if lastSceneName == null:
#			lastSceneName = sceneName
#		elif sceneName != lastSceneName:
#			lastSceneName = sceneName
		
	# if scene has loaded a level, start emitting that string from now on
#	if fileToReturn == true:
#		path = "res://MapFiles/Maps/Level_" + str(levelID) + ".txt"
##		returnedLevelPath.emit(path)
#		print("emitting")
		# print("returning path")
	# if the scene is the Gamelevel scene, connect to it so it can say it's received
	# which will turn the pathToReturn bool to false, so it is no longer emitting
	# in other words, resetting back to normal
#	if sceneName == "Gamelevel" and connectedToGameLevel == false:
#		print("attempting to connect")
#		scene.pathReceived.connect(_path_received)
#		connectedToGameLevel = true

#func _return_file(fileID):
#	fileToReturn = true
#	levelID = fileID

#func _path_received():
#	fileToReturn = false
	
