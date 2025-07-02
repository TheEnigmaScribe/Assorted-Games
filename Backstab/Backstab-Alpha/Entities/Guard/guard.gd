extends Node2D

signal wallcheck

var direction: String
var nodes: Dictionary

func _ready():
	pass

func turn(direction):
	if direction == "Left":
		pass
	elif direction == "Right":
		pass
	elif direction == "Up":
		pass
	elif direction == "Down":
		pass
	wallcheck.emit(direction)
