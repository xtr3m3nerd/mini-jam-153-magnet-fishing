extends Control

@onready var play_button: Button = $Buttons/PlayButton
@onready var exit_button: Button = $Buttons/ExitButton

@export var buttons_with_sounds: Array[BaseButton] = []
@export var sliders_with_sounds: Array[Slider] = []

@onready var game_scene: PackedScene = SceneManager.level_scene
@export var credit_scene: PackedScene = preload("res://menu/credits_menu.tscn")
@export var rules_scene: PackedScene = preload("res://menu/rules.tscn")

func _ready():
	play_button.grab_focus()
	match OS.get_name():
		"Web":
			exit_button.hide()
	MusicManager.play_music()
	UiSfxManager.add_buttons(buttons_with_sounds)
	UiSfxManager.add_sliders(sliders_with_sounds)
	PlayerManager.reset()
	PauseManager.paused = false

func _unhandled_input(event):
	if event.is_action_pressed("back"):
		exit_game()

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(game_scene)


func _on_credits_button_pressed():
	var credits = credit_scene.instantiate()
	add_child(credits)


func _on_exit_button_pressed():
	exit_game()

func exit_game():
	if OS.get_name() == "Web":
		return
	get_tree().quit()


func _on_rules_button_pressed():
	var rules = rules_scene.instantiate()
	add_child(rules)
