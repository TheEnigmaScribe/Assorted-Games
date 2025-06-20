extends Node2D

@onready var sprite_2d = $TerminalSprite

enum {Left = 1, Up = 2, Right = 3, Down = 4}

var direction
var id

var interactCounter: int = 0

var textbox: Dictionary

func _ready():
	if direction == "Left":
		sprite_2d.texture.region = Rect2(0, 64, 32, 32)
	elif direction == "Up":
		sprite_2d.texture.region = Rect2(32, 64, 32, 32)
	elif direction == "Right":
		sprite_2d.texture.region = Rect2(64, 64, 32, 32)
	elif direction == "Down":
		sprite_2d.texture.region = Rect2(96, 64, 32, 32)

func _interact_text():
	if interactCounter == textbox.size():
		interactCounter = 0
		# exit out of textbox
	else:
		# later swap out for proper textbox display stuff
		print(textbox["Line" + str(interactCounter) + "_Sprite"])
		print(textbox["Line" + str(interactCounter)])
