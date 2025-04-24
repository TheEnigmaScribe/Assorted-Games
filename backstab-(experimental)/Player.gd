extends Sprite2D

@onready var tile_map = $"../TileMapLayer"
@onready var sprite_2d: Sprite2D = $PlayerSprite

var is_moving = false
var facing = "Down"

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
	spriteFacing(facing)
	if is_moving == true:
		return
	# if Input.is_action_just_pressed("cDash"):
	if Input.is_action_just_pressed("stab"):
		if facing == "Left":
			pass
		elif facing == "Right":
			pass
		elif facing == "Up":
			pass
		elif facing == "Down":
			pass
		stab(facing)
	elif Input.is_action_just_pressed("left"):
		move(Vector2.LEFT)
		facing = "Left"
	elif Input.is_action_just_pressed("right"):
		move(Vector2.RIGHT)
		facing = "Right"
	elif Input.is_action_just_pressed("up"):
		move(Vector2.UP)
		facing = "Up"
	elif Input.is_action_just_pressed("down"):
		move(Vector2.DOWN)
		facing = "Down"

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

func spriteFacing(looking):
	if looking == "Left":
		sprite_2d.texture.region = Rect2(32, 32, 32, 32)
	if looking == "Right":
		sprite_2d.texture.region = Rect2(0, 0, 32, 32)
	if looking == "Up":
		sprite_2d.texture.region = Rect2(0, 32, 32, 32)
	if looking == "Down":
		sprite_2d.texture.region = Rect2(32, 0, 32, 32)

func stab(looking):
	pass
