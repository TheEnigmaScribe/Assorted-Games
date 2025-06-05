extends Node

signal returnedFolderPath(string: String)

var path: String
var levelFolderPath: String
var pathToReturn: bool = false
var connectedToGameLevel = false

func _process(delta):
	var scene = get_tree().current_scene
	var currentScene: Array = str(get_tree().current_scene).split(":")
	var sceneName: String = currentScene[0]
	# connect to scene if scene can load level
	if sceneName == "DevWindow" or sceneName == "LevelSelection" or sceneName == "Campaign":
		scene.folderPath.connect(_return_folder_path)
	# if scene has loaded a level, start emitting that string from now on
	if pathToReturn == true:
		returnedFolderPath.emit(levelFolderPath)
	# if the scene is the Gamelevel scene, connect to it so it can say it's received
	# which will turn the pathToReturn bool to false, so it is no longer emitting
	# in other words, resetting back to normal
	if sceneName == "Gamelevel" and connectedToGameLevel == false:
		scene.pathReceived.connect(_path_received)
		connectedToGameLevel = true

func _return_folder_path(pathToLoad):
	pathToReturn = true
	levelFolderPath = pathToLoad

func _path_received():
	pathToReturn = false
	
