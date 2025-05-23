extends Node2D
	
@onready var sprite_2d: Sprite2D = $SniperSprite
@onready var raycast_2d: RayCast2D = $SniperRaycast

var instructions = []

# var spinning: bool
# var moving: bool
var initialFacing: String
var facing: String
# var movementPath: String

func _ready():
	# set default values here
# 	spinning = true
# 	moving = false
# 	movementPath = "none"
	facing = "Right"
	
func _process(delta):
	if raycast_2d.is_colliding():
		onPlayerDetection()

func _on_player_player_step():
	if facing == "Left":
		facing = "Up"
	elif facing == "Up":
		facing = "Right"
	elif facing == "Right":
		facing = "Down"
	elif facing == "Down":
		facing = "Left"
	spriteFacing(facing)

func spriteFacing(looking):
	var raycast_direction: Vector2
	if looking == "Left":
		sprite_2d.texture.region = Rect2(96, 32, 32, 32)
		raycast_direction = Vector2.LEFT
	elif looking == "Right":
		sprite_2d.texture.region = Rect2(64, 0, 32, 32)
		raycast_direction = Vector2.RIGHT
	elif looking == "Up":
		sprite_2d.texture.region = Rect2(64, 32, 32, 32)
		raycast_direction = Vector2.UP
	elif looking == "Down":
		sprite_2d.texture.region = Rect2(96, 0, 32, 32)
		raycast_direction = Vector2.DOWN
	
	# if horizontal view
	if looking == "Left" or looking == "Right":
		raycast_2d.target_position = raycast_direction * Vector2(16, 1) * 32
	
	# if vertical view
	if looking == "Up" or looking == "Down":
		raycast_2d.target_position = raycast_direction * Vector2(1, 16) * 32
		
func onPlayerDetection():
	# sprite_2d.texture_region = Rect2(192, 96, 32, 32)
	pass
