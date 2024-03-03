extends Control

# TODO - This is where we will display credits for all the creators as well credits for any assets that we have been using

@onready var back_button = $VBoxContainer/BackButton
var last_focus = null

func _ready():
	last_focus = get_viewport().gui_get_focus_owner()
	back_button.grab_focus()
	UiSfxManager.add_button(back_button)

func _unhandled_input(event):
	if event.is_action_pressed("back"):
		close()

func close():
	if last_focus != null:
		last_focus.grab_focus()
	queue_free()

func _on_back_button_pressed():
	close()
