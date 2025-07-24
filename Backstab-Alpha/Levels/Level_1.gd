extends Node2D

signal changeScene
signal escapeMenu

# store any map specific variables here

# settings, enemies, player spawn, cutscenes, terminal dialogue, etc

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		escapeMenu.emit()
