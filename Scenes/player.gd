extends Node2D

var tileSize = 64
var onCooldown = false
var facing = "lookingDown"
var is_moving = false
var movingX = 0
var movingY = 0
var targetPosition: Vector2

func _on_cooldown_timeout():
	onCooldown = false
	
func _process(delta):
	if Input.is_action_just_pressed("stab"):
		#var canStab = isEnemyInFront(global_position?)
		# if canStab:
			# enemyStab(enemyLooking, enemyInFront)
		pass
	if is_moving:
		return
	# Movment processing
	if InputEvent:
		if Input.is_action_pressed("left"):
			facing = "lookingLeft"
			movingX = -64
		elif Input.is_action_pressed("right"):
			facing = "lookingRight"
			movingX = 64
		elif Input.is_action_pressed("up"):
			facing = "lookingUp"
			movingY = -64
		elif Input.is_action_pressed("down"):
			facing = "lookingDown"
			movingY = 64

	if (movingX != 0) or (movingY != 0):
		if movingX != 0:
			targetPosition.x = global_position.x + movingX
			if targetPosition.x != global_position.x:
				global_position.x += 64 * delta * sign(movingX)
			elif targetPosition.x == global_position.x:
				movingX = 0
		if movingY != 0:
			var targetPosition: Vector2 = global_position.y + movingY
			if targetPosition.y != global_position.y:
				global_position.y += 64 * delta * sign(movingY)
			elif targetPosition.y == global_position.y:
				movingY = 0

func enemyStab(enemyLooking, enemyInFront):
	if enemyInFront:
		pass
	if enemyLooking == facing:
		pass
