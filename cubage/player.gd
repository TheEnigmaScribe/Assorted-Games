extends CharacterBody2D

@onready var RayLeft: RayCast2D = $RaycastLeft
@onready var RayRight: RayCast2D = $RaycastRight
@onready var RayUp: RayCast2D = $RaycastUp
@onready var RayDown: RayCast2D = $RaycastDown
@onready var MagLeft: Sprite2D = $LeftMagnet
@onready var MagRight: Sprite2D = $RightMagnet
@onready var MagUp: Sprite2D = $UpMagnet
@onready var MagDown: Sprite2D = $DownMagnet

var magnets: Dictionary = {"Left": false, "Right": false, "Up": false, "Down": false}

func _ready():
	trigger("Left")
	trigger("Right")
	trigger("Up")
	trigger("Down")

func _process(delta):
	if Input.is_action_just_pressed("left"):
		if magnets["Left"]:
			magnets["Left"] = false
		elif !magnets["Left"]:
			magnets["Left"] = true
		trigger("Left")
	elif Input.is_action_just_pressed("right"):
		if magnets["Right"]:
			magnets["Right"] = false
		elif !magnets["Right"]:
			magnets["Right"] = true
		trigger("Right")
	elif Input.is_action_just_pressed("up"):
		print("up")
		if magnets["Up"]:
			magnets["Up"] = false
		elif !magnets["Up"]:
			magnets["Up"] = true
		trigger("Up")
	elif Input.is_action_just_pressed("down"):
		print("down")
		if magnets["Down"]:
			magnets["Down"] = false
		elif !magnets["Down"]:
			magnets["Down"] = true
		trigger("Down")

func trigger(direction):
	if direction == "Left":
		if magnets["Left"]:
			MagLeft.show()
			RayLeft.enabled = true
		else: 
			MagLeft.hide()
			RayLeft.enabled = false
		return
	elif direction == "Right":
		if magnets["Right"]:
			MagRight.show()
			RayRight.enabled = true
		else:
			MagRight.hide()
			RayRight.enabled = false
		return
	elif direction == "Up":
		if magnets["Up"]:
			MagUp.show()
			RayUp.enabled = true
		else:
			MagUp.hide()
			RayUp.enabled = false
		return
	elif direction == "Down":
		if magnets["Down"]:
			MagDown.show()
			RayDown.enabled = true
		else:
			MagDown.hide()
			RayDown.enabled = false
		return
