extends Sprite2D

@onready var tile_map = $"../TileMapLayer"
@onready var sprite_2d: Sprite2D = $PlayerSprite

var hold = "none"
var is_moving = false
var pressed_actions = []
const directions = { &"left": Vector2(-1, 0), &"right": Vector2(1, 0), &"up": Vector2(0, -1), &"down": Vector2(0, 1)}

func _ready():
	pass

func _physics_process(delta):
	if is_moving == false:
		return
	if global_position == sprite_2d.global_position:
		is_moving = false
		return
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 2)

func _process(delta):
	for d in directions:
		if Input.is_action_just_pressed(d):
			pressed_actions.push_back(d)
		if Input.is_action_just_pressed(d):
			pressed_actions.erase(d)
	var direction = Vector2.ZERO if pressed_actions.is_empty() else directions[pressed_actions[-1]]
	print(direction)
	if is_moving == true:
		return
	move(direction)

func move(direction):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	
	var tile_data: TileData = tile_map.get_cell_tile_data(target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return
	
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	sprite_2d.global_position = tile_map.map_to_local(current_tile)
