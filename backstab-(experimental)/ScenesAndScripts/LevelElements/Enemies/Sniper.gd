extends Node2D

enum {Left = 1, Up = 2, Right = 3, Down = 4}
enum {OnPatrol = 1, NoticedSomething = 2, OnAlert = 3, Dead = 4}

signal playerSeen

@onready var bulletScene = preload("res://ScenesAndScripts/LevelElements/Enemies/SniperBullet.tscn")
@onready var game_level = get_tree().get_first_node_in_group("gamelevel")
@onready var tile_map = get_tree().get_first_node_in_group("tilemaplayer")
var player: Sprite2D
var playerHitbox: Area2D
@onready var sprite_2d: Sprite2D = $SniperSprite
@onready var raycast_2d: RayCast2D = $SniperRaycast
@onready var wallchecker: Node2D = $SniperWallcheck
@onready var area_2d: Area2D = $EnemyCollision


var instPath: Node2D
var id: String = "invalidID"
var facing
var initialFacing
var instructions: String
var customBehavior: bool
var entityInfo: Dictionary
var is_moving: bool
var playerDetected: bool = false
var orientationSet: bool = true

# determines enemy behavior
# NoticedSomething and OnAlert are future possibilities for more ways the enemy can behave
# NoticedSomething would have the enemy deviate from its patrol sequence to go off a few tiles to whatever it noticed
# and if it doesn't find anything, it goes back to where it used to be
# probably would keep a sequence of actions/saved tile coordinates to go back to and resume patrol if so
# OnAlert is for a phase 2
# if the player dashes past an enemy's vision, all enemies in the map go on alert
# if the player is spotted again (even through dashing) all enemies start chasing after player (quickest path possible)
var enemyState = OnPatrol

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
	# set instance version of entityInfo dict of gamelevel version of entityInfo dict
	entityInfo = game_level.entityInfo
	# connect gamelevel signals to methods to fill in information when available
	# done this way so the code that uses the information isn't run before it can be loaded
	game_level.connectToPlayer.connect(_connect_to_player)
	game_level.instructionsFilled.connect(_register_sequence)
	game_level.gameOver.connect(_game_over_sequence)

# process methods, used for player detection and movement processing
func _process(_delta):
	if playerDetected == false:
		if raycast_2d.is_colliding():
			var seenObject = raycast_2d.get_collider()
			if seenObject == playerHitbox:
				playerDetected = true
				playerSeen.emit()
	elif playerDetected == true:
		pass

func _physics_process(_delta):
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
	# print(entityInfo["Instructions" + id])
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
	if tile_data.get_custom_data("solid") == true:
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

func _game_over_sequence():
	# checks playerDetected to make sure that this only triggers on enemy that detected player
	if playerDetected == true:
		pass
		# print("playerDetected")
		# pass
		# var bullet = bulletScene.instantiate()
		# add_child(bullet)
		# could be later added to the entityList instead, but works for now
		# bullet.direction = facing if necessary

func _is_enemy_killed(nodeSeen, playerFacing):
	print("enemynode area2d is " + str(area_2d))
	if nodeSeen == area_2d:
		# checks if player is behind the enemy
		if facing == playerFacing:
			print("Enemy " + id + " has been killed")
			queue_free()
			# run death animation/deletion? or just turn state to dead
			pass
		else:
			# go on alert, probably, maybe dodge back? idk, but nothing yet
			pass
	else:
		pass

# variable setting methods
func _connect_to_player():
	var playerNodes = get_tree().get_nodes_in_group("player")
	print(playerNodes)
	for i in playerNodes:
		if i is Sprite2D:
			player = i
			player.playerStep.connect(_on_player_step)
			player.whatWasHit.connect(_is_enemy_killed)
			print("player filled with: " + str(player))
		elif i is Area2D:
			playerHitbox = i
			print("playerHitbox filled with: " + str(playerHitbox))

func _register_sequence():
	initialFacing = entityInfo["InitFacing" + id]
	print(id + " should be facing " + initialFacing)
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
	instructions = entityInfo["Instructions" + id]
	if instructions == "null":
		customBehavior = false
	else:
		customBehavior = true
	print(id + " Instructions: " + instructions)

func _go_on_alert():
	# runs sequence if an enemy detected the player while dashing/didn't kill the player
	# runs for all enemies, as the alert state affects whole map
	enemyState = OnAlert
