extends CharacterBody2D

func _process(delta):
	
	# direction
	var direction = Vector2(1,0)
	
	# velocity
	velocity = direction * 250
	
	# move and slide
	move_and_slide()
