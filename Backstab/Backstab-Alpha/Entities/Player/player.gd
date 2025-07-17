extends CharacterBody2D

@onready var sprite_2d_player: Sprite2D = $PlayerSprite
@onready var raycast2d: RayCast2D = $InteractionRaycast
#@onready var sprite_2d_indicator: Sprite2D = $MovementIndicatorSprite

var looking: String = "down"
var spriteDir: String
var movementDirection: Vector2
var speed: int = 160
var lastMovement
var input

var cooldowns: Dictionary = {"stab": false, "dash": false}

func _ready():
	pass
	
func _physics_process(delta):
	input = Input.get_vector("left", "right", "up", "down")
	#if movementDirection != Vector2.ZERO:
	#if movementDirection != lastMovement:
	#	print(movementDirection)
	#	lastMovement = movementDirection
	velocity = input * speed
	# print(velocity)
	# no need to multiply by delta since it's already included
	# global_position += Vector2(velocity.x * delta, velocity.y * delta)
	move_and_slide()
	# add collision soonish

func _process(delta):
	
	#if velocity != Vector2(0, 0):
	#	print(velocity)
	# possibly make these pause the player's movement before and while using them?
	#if Input.is_action_just_pressed("left"):
	#	turn("left")
	#elif Input.is_action_just_pressed("right"):
	#	turn("right")
	#elif Input.is_action_just_pressed("up"):
	#	turn("up")
	#elif Input.is_action_just_pressed("down"):
	#	turn("down")
	#if Input.is_action_just_pressed("stab"):
	#	if cooldowns["stab"]:
	#		return
	#	stab(looking)
	#elif Input.is_action_just_pressed("interact"):
	#	if raycast2d.is_colliding():
	#		var collider = raycast2d.get_collider
	#		if collider.has_node("Interactable"):
	#			interact(looking)
	#else:
	pass
	

#func turn(dir):
#	return
#	if dir == "left":
#		sprite_2d_player.texture.region = Rect2(0, 0, 32, 32)
#	elif dir == "up":
#		sprite_2d_player.texture.region = Rect2(32, 0, 32, 32)
#	elif dir == "right":
#		sprite_2d_player.texture.region = Rect2(64, 0, 32, 32)
#	elif dir == "down":
#		sprite_2d_player.texture.region = Rect2(96, 0, 32, 32)

#func stab(dir):
#	# play animation, sound, and signal the enemy to be dead
#	print("stab")
#	pass

#func interact(dir):
#	print("interact")
#	pass
