extends Camera2D

enum {FollowPlayer = 0, FollowPoint = 1}

var cameraMode = FollowPlayer

func _process(delta):
	if cameraMode == 0:
		if global_position != $"../Player".global_position:
			global_position = $"../Player".global_position
