extends Node

@onready var pause_screen = $CanvasLayer/PauseScreen

var paused = false

func _ready():
	pause_screen.hide()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		print("pause: " + str(paused))
		if paused:
			get_tree().paused = true
			pause_screen.show()
		else:
			get_tree().paused = false
			pause_screen.hide()
