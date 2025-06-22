extends Sprite2D

var player: Sprite2D

		

func _on_gamelevel_connect_to_player():
	var playernodes = get_tree().get_nodes_in_group("player")
	for i in playernodes:
		if i is Sprite2D:
			player = i
			player.playerStep.connect(_center_on_player)

func _center_on_player():
	global_position = player.global_position
