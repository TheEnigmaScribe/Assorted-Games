extends Node2D

enum {Left = 1, Up = 2, Right = 3, Down = 4}

var direction
var orientation: String

func _ready():
	# only works if sniper is parent, change to sniper giving direction value if not
	# var endpoint = get_parent().raycast_endpoint
	if direction == 1 or direction == 3:
		orientation = "horizontal"
	elif direction == 2 or direction == 4:
		orientation = "vertical"

func _process(_delta):
	pass
	# print(direction)
	#if 
