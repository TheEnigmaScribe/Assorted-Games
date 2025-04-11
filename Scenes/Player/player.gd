extends CharacterBody2D

var can_laser: bool = true
var can_grenade: bool = true

signal player_laser
signal player_grenade

func _ready():
	pass
	


func _process(_delta):
	
	# player movement direction vector and movement
	var playerDirection = Input.get_vector("left", "right", "up", "down")
	velocity = playerDirection * 500
	move_and_slide()

	if Input.is_action_pressed("primary action") and can_laser:
		print("shoot gun!")
		# player.shoot()
		$LaserTimer.start()
		can_laser = false
		player_laser.emit()

	if Input.is_action_pressed("secondary action") and can_grenade:
		print("grenade!")
		# player.shoot()
		$GrenadeTimer.start()
		can_grenade = false
		player_grenade.emit()

# laser cooldown
func _on_laser_timer_timeout():
	can_laser = true

# grenade cooldown
func _on_grenade_timer_timeout():
	can_grenade = true
