extends Control

@onready var play_button: Button = $Buttons/PlayButton
@onready var exit_button: Button = $Buttons/ExitButton

@export var buttons_with_sounds: Array[BaseButton] = []
@export var sliders_with_sounds: Array[Slider] = []

@onready var game_scene: PackedScene = SceneManager.intro_scene
@export var rules_scene: PackedScene = preload("res://menu/rules.tscn")

var selectfx_player := AudioStreamPlayer.new()

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
	add_child(selectfx_player)

func _unhandled_input(event):
	if event.is_action_pressed("back"):
		exit_game()

func _on_play_button_pressed():
	var leave_effect = load("res://assets/sfx/kaching.wav")
	selectfx_player.stream = leave_effect
	selectfx_player.play()
	await selectfx_player.finished
	get_tree().change_scene_to_packed(game_scene)


func _on_credits_button_pressed():
	SceneManager.change_to_credits()



func _on_exit_button_pressed():
	exit_game()

func exit_game():
	if OS.get_name() == "Web":
		return
	get_tree().quit()


func _on_rules_button_pressed():
	var rules = rules_scene.instantiate()
	add_child(rules)
