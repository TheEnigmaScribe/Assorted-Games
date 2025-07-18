extends Control

signal changeScene

func _ready():
	# finds upper left corner and sets position there
	var screenCenter = get_screen_position()
	var screenSize = get_viewport_rect()
	global_position.x = -screenSize.size.x/2 - screenCenter.x
	global_position.y = -screenSize.size.y/2 - screenCenter.y

func _process(delta):
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = false
		queue_free()

func _on_main_pressed():
	changeScene.emit("Main", "Escape")

func _on_quit_pressed():
	# save data before quiting, or show prompt for that?
	get_tree().quit()
