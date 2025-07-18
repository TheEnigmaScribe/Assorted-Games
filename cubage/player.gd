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
var move: Dictionary = {"Left": false, "Right": false, "Up": false, "Down": false}
var mode = "+"
var movementDirection: Vector2
var speed = 500
var acceleration = 5

func _ready():
	trigger("Left")
	trigger("Right")
	trigger("Up")
	trigger("Down")
	trigger("Left")
	trigger("Right")
	trigger("Up")
	trigger("Down")

func _physics_process(delta):
	collisionCheck()
	if move["Left"] != "None":
		if move["Left"] == "Toward":
			movementDirection.x = -1
		elif move["Left"] == "Away":
			movementDirection.x = 1
	else:
		movementDirection.x = 0
	if move["Right"] != "None":
		if move["Right"] == "Toward":
			movementDirection.x = 1
		elif move["Right"] == "Away":
			movementDirection.x = -1
	else:
		movementDirection.x = 0
	if move["Up"] != "None":
		if move["Up"] == "Toward":
			movementDirection.y = -1
		elif move["Up"] == "Away":
			movementDirection.y = 1
	else:
		movementDirection.y = 0
	if move["Down"] != "None":
		if move["Down"] == "Toward":
			movementDirection.y = 1
		elif move["Down"] == "Away":
			movementDirection.y = -1
	else:
		movementDirection.y = 0
	velocity = Vector2(movementDirection.x * speed, movementDirection.y * speed)
	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("shift"):
		if mode == "+":
			mode = "-"
		elif mode == "-":
			mode = "+"
	elif Input.is_action_just_pressed("left"):
		trigger("Left")
	elif Input.is_action_just_pressed("right"):
		trigger("Right")
	elif Input.is_action_just_pressed("up"):
		trigger("Up")
	elif Input.is_action_just_pressed("down"):
		trigger("Down")

func collisionCheck():
	var collider
	var colliderCharge
	if RayLeft.is_colliding():
		collider = RayLeft.get_collider()
		colliderCharge = collider.get_name().substr(0, 1)
		if colliderCharge == mode:
			move["Left"] = "Toward"
		else:
			move["Left"] = "Away"
	else:
		move["Left"] = "None"
	
	if RayRight.is_colliding():
		collider = RayRight.get_collider()
		colliderCharge = collider.get_name().substr(0, 1)
		if colliderCharge == mode:
			move["Right"] = "Toward"
		else:
			move["Right"] = "Away"
	else:
		move["Right"] = "None"
	
	if RayUp.is_colliding():
		collider = RayUp.get_collider()
		colliderCharge = collider.get_name().substr(0, 1)
		if colliderCharge == mode:
			move["Up"] = "Toward"
		else:
			move["Up"] = "Away"
	else:
		move["Up"] = "None"
	if RayDown.is_colliding():
		collider = RayDown.get_collider()
		colliderCharge = collider.get_name().substr(0, 1)
		if colliderCharge == mode:
			move["Down"] = "Toward"
		else:
			move["Down"] = "Away"
	else:
		move["Down"] = "None"

func trigger(dir):
	if dir == "Left":
		if magnets["Left"]:
			magnets["Left"] = false
			MagLeft.hide()
			RayLeft.enabled = false
		elif !magnets["Left"]:
			magnets["Left"] = true
			MagLeft.show()
			RayLeft.enabled = true
	elif dir == "Right":
		if magnets["Right"]:
			magnets["Right"] = false
			MagRight.hide()
			RayRight.enabled = false
		elif !magnets["Right"]:
			magnets["Right"] = true
			MagRight.show()
			RayRight.enabled = true
	elif dir == "Up":
		if magnets["Up"]:
			magnets["Up"] = false
			MagUp.hide()
			RayUp.enabled = false
		elif !magnets["Up"]:
			magnets["Up"] = true
			MagUp.show()
			RayUp.enabled = true
	elif dir == "Down":
		if magnets["Down"]:
			magnets["Down"] = false
			MagDown.hide()
			RayDown.enabled = false
		elif !magnets["Down"]:
			magnets["Down"] = true
			MagDown.show()
			RayDown.enabled = true
