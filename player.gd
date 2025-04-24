extends Sprite2D

@onready var tile_map = $"../TileMapLayer"
@onready var sprite_2d: Sprite2D = $PlayerSprite

var is_moving = false

func _physics_process(delta):
	if is_moving == false:
		return
	if global_position == sprite_2d.global_position:
		is_moving = false
		return
	sprite_2d.global_position = sprite_2d.global_position.move_toward(global_position, 2)

func _process(delta):
	if is_moving == true:
		return
	# if Input.is_action_just_pressed("cDash"):
	if Input.is_action_just_pressed("stab"):
		pass
	elif Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_just_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)

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
