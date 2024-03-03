extends Node

@onready var pause_screen = $CanvasLayer/PauseScreen
var last_focus = null

var paused = false:
	set(value):
		paused = value
		_update_pause_state(value)

func _ready():
	_update_pause_state(paused)

func _process(_delta):
	if Input.is_action_just_pressed("pause") and not get_tree().current_scene.is_in_group("menu"):
		paused = !paused
		

func _update_pause_state(pause_state: bool) -> void:
	if !pause_screen:
		return
	get_tree().paused = pause_state
	pause_screen.visible = pause_state
	
	if(pause_state == true):
		last_focus = get_viewport().gui_get_focus_owner()
		$CanvasLayer/PauseScreen/MainMenuButton.grab_focus()
	else:
		if(last_focus != null):
			last_focus.grab_focus()
	
	
func _on_main_menu_button_pressed():
	SceneManager.change_to_menu()
