extends Node2D

enum {Left = 1, Up = 2, Right = 3, Down = 4}

@onready var game_level = get_tree().get_first_node_in_group("gamelevel")
@onready var tile_map = get_tree().get_first_node_in_group("tilemaplayer")
var player: Sprite2D
@onready var sprite_2d: Sprite2D = $SniperSprite
@onready var raycast_2d: RayCast2D = $SniperRaycast
@onready var wallchecker: Node2D = $SniperWallcheck


var instPath: Node2D
var id: String = "invalidID"
var facing
var initialFacing
var instructions: String
var customBehavior: bool
var enemyInfo: Dictionary
var is_moving: bool

var sequenceComplete: bool = false
var currentChar: int = -1

# Used in determining direction
var toFace: int

func _ready():
	# default facing in case a proper value isn't loaded
	facing = Right
	# run raycast endpoint check initially
	var raycast_endpoint = wallchecker.findRaycastEndpoint(facing, id)
	raycast_2d.target_position = raycast_endpoint
	# set instance version of enemyInfo dict of gamelevel version of enemyInfo dict
	enemyInfo = game_level.enemyInfo
	# connect gamelevel signals to methods to fill in information when available
	# done this way so the code that uses the information isn't run before it can be loaded
	game_level.connectToPlayer.connect(_connect_to_player)
	game_level.instructionsFilled.connect(_register_sequence)

# process methods
func _process(delta):
	if raycast_2d.is_colliding():
		var seenObject = raycast_2d.get_collider()
		if seenObject == get_tree().get_first_node_in_group("player"):
			onPlayerDetection()

func _physics_process(delta):
	if is_moving == false:
		return
	if sprite_2d.global_position == global_position:
		is_moving = false
		return
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 2)

# movement methods
func _on_player_step():
	if customBehavior == true:
		runNextInSequence()
	elif customBehavior == false:
		return
	# var raycast_endpoint = wallchecker.findRaycastEndpoint(facing, id)
	# print(raycast_endpoint)
	# raycast_2d.target_position = raycast_endpoint

func runNextInSequence():
	# print(enemyInfo["Instructions" + id])
	# first time this is run actually starts from 0 due to being -1 initially
	var loopSequence: bool
	var parts = instructions.split("/")
	currentChar += 1
	if parts[0] == "Y":
		loopSequence = true
	elif parts[0] == "N":
		loopSequence = false
	var sequence = parts[1]
	if sequenceComplete:
		return
	var nextInst = sequence.substr(currentChar, 1)
	if nextInst == "M":
		move(facing)
	elif nextInst == "L" or nextInst == "R" or nextInst == "U":
		facing = whatDirection(facing, nextInst)
		turn(facing)
	elif nextInst == "H":
		pass
	elif nextInst == "X":
		if loopSequence == true:
			currentChar = 0
			nextInst = sequence.substr(currentChar, 1)
			if nextInst == "M":
				move(facing)
			elif nextInst == "L" or nextInst == "R" or nextInst == "U":
				facing = whatDirection(facing, nextInst)
				turn(facing)
		elif loopSequence == false:
			sequenceComplete = true

func move(facing):
	# get direction
	var direction: Vector2i
	if facing == Left:
		direction = Vector2i.LEFT
	elif facing == Up:
		direction = Vector2i.UP
	elif facing == Right:
		direction = Vector2i.RIGHT
	elif facing == Down:
		direction = Vector2i.DOWN
	
	# tilemap movement code
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	
	# checks if target_tile can be moved to or not, and stops movement code if unable
	var tile_data: TileData = tile_map.get_cell_tile_data(target_tile)
	if tile_data.get_custom_data("walkable") == false:
		return
	
	# extends raycast towards target_tile to check that if it's occupied, cancels if so
	raycast_2d.target_position = direction * 32
	raycast_2d.force_raycast_update()
	if raycast_2d.is_colliding():
		return
	
	# moving set to true for use in physics processing so that it isn't constantly running
	is_moving = true
	# Node2D position set to target_tile while sprite position is set to current tile
	# This is so the enemy "moves" instead of teleporting to the intended position
	# also prevents instantaneous movement
	global_position = tile_map.map_to_local(target_tile)
	sprite_2d.global_position = tile_map.map_to_local(current_tile)
	pass

func whatDirection(facing, turn):
	# directional calculations
	var turnTo = facing
	if turn == "L":
		turnTo -= 1
		# if turnTo is left/1 and turns left/-1 and goes negative, wrap around to down/4
		if turnTo <= 0:
			turnTo += 4
	elif turn == "R":
		turnTo += 1
		# if turnTo is down/4 and turns right/+1 and goes negative, wrap around to left/1
		if turnTo >= 5:
				turnTo -= 4
	elif turn == "U":
		turnTo += 2
		# if turnTo is past down/4, remove one loop/4 from value
		if turnTo >= 5:
			turnTo -= 4
	# print("turnTo = " + str(turnTo))
	return turnTo

func turn(looking):
	# sets sprite to appropriate visual
	if looking == Left:
		sprite_2d.texture.region = Rect2(96, 32, 32, 32)
	elif looking == Right:
		sprite_2d.texture.region = Rect2(64, 0, 32, 32)
	elif looking == Up:
		sprite_2d.texture.region = Rect2(64, 32, 32, 32)
	elif looking == Down:
		sprite_2d.texture.region = Rect2(96, 0, 32, 32)
	
	# updates raycast
	var raycast_endpoint = wallchecker.findRaycastEndpoint(looking, id)
	raycast_2d.target_position = raycast_endpoint

# player detection method
func onPlayerDetection():
	print("Player detected")

# variable setting methods
func _connect_to_player():
	player = get_tree().get_first_node_in_group("player")
	player.playerStep.connect(_on_player_step)

func _register_sequence():
	initialFacing = enemyInfo["InitFacing" + id]
	if initialFacing != null:
		if initialFacing == "L":
			initialFacing = Left
		elif initialFacing == "U":
			initialFacing = Up
		elif initialFacing == "R":
			initialFacing = Right
		elif initialFacing == "D":
			initialFacing = Down
		facing = initialFacing
		turn(facing)
	instructions = enemyInfo["Instructions" + id]
	if instructions == null:
		customBehavior = false
	else:
		customBehavior = true
	print(id + " Instructions: " + instructions)
