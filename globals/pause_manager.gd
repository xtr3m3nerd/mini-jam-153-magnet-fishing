extends Node

@onready var pause_screen = $CanvasLayer/PauseScreen

var paused = false:
	set(value):
		paused = value
		_update_pause_state(value)

func _ready():
	_update_pause_state(paused)

func _process(_delta):
	if Input.is_action_just_pressed("pause") and not get_tree().current_scene.is_in_group("menu"):
		paused = !paused
		if paused:
			get_tree().paused = true
			pause_screen.show()
		else:
			get_tree().paused = false
			pause_screen.hide()

func _update_pause_state(pause_state: bool) -> void:
	if !pause_screen:
		return
	get_tree().paused = pause_state
	pause_screen.visible = pause_state
		
func _on_main_menu_button_pressed():
	SceneManager.change_to_menu()
