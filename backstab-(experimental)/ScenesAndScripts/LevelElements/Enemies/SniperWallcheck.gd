extends Node2D

enum {Left = 1, Up = 2, Right = 3, Down = 4}

@onready var tile_map = get_tree().get_first_node_in_group("tilemaplayer")

var direction: Vector2i
var raycast_endpoint: Vector2i

func findRaycastEndpoint(facing, id):
	# this is essentially the same as the player movement code
	# primarily because this checks tilemaplayer data layers
	# otherwise the enemy would be able to see through walls
	# so it finds out where the nearest wall is, and then returns its position
	# the raycast is then set to that point in the sniper.gd script
	position = Vector2i(0, 0)
	for i in 20:
		# print(position)
		var current_tile: Vector2i = tile_map.local_to_map(global_position)
		if facing == Left:
			direction = Vector2.LEFT
		elif facing == Right:
			direction = Vector2.RIGHT
		elif facing == Up:
			direction = Vector2.UP
		elif facing == Down:
			direction = Vector2.DOWN
			
		var target_tile: Vector2i = Vector2i(
			current_tile.x + direction.x,
			current_tile.y + direction.y
		)
		
		var tile_data: TileData = tile_map.get_cell_tile_data(target_tile)
		
		# print(id + ": " + str(target_tile))
		if tile_data.get_custom_data("solid") == true:
			raycast_endpoint = position
			position = Vector2i(0, 0)
			# print(raycast_endpoint)
			return raycast_endpoint
		else:
			global_position = tile_map.map_to_local(target_tile)
	if raycast_endpoint == null:
		raycast_endpoint = global_position
		return raycast_endpoint
