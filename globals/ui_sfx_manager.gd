extends Node

@export var button_hover_sound: AudioStream
@export var button_press_sound: AudioStream

@onready var audio_player: AudioStreamPlayer = $ButtonNoises

var debounce: bool = false

func _ready():
	print(str(audio_player))

func play_button_press() -> void:
	audio_player.stream = button_press_sound
	audio_player.play()
	
func play_slider_changed(_value: float) -> void:
	if debounce == false:
		debounce = true
		play_button_hover()

func play_button_hover() -> void:
	audio_player.stream = button_hover_sound
	audio_player.play()

func add_button(button: BaseButton) -> void:
	if not button.pressed.is_connected(play_button_press):
		button.pressed.connect(play_button_press)
	if not button.mouse_entered.is_connected(play_button_hover):
		button.mouse_entered.connect(play_button_hover)

func remove_button(button: BaseButton) -> void:
	if button.pressed.is_connected(play_button_press):
		button.pressed.disconnect(play_button_press)
	if button.mouse_entered.is_connected(play_button_hover):
		button.mouse_entered.disconnect(play_button_hover)

func add_buttons(buttons: Array[BaseButton]) -> void:
	for button in buttons:
		add_button(button)
		
func remove_buttons(buttons: Array[BaseButton]) -> void:
	for button in buttons:
		remove_button(button)

func add_slider(slider: Slider) -> void:
	if not slider.value_changed.is_connected(play_slider_changed):
		slider.value_changed.connect(play_slider_changed)
	if not slider.mouse_entered.is_connected(play_button_hover):
		slider.mouse_entered.connect(play_button_hover)

func remove_slider(slider: Slider) -> void:
	if slider.value_changed.is_connected(play_slider_changed):
		slider.value_changed.disconnect(play_slider_changed)
	if slider.mouse_entered.is_connected(play_button_hover):
		slider.mouse_entered.disconnect(play_button_hover)

func add_sliders(sliders: Array[Slider]) -> void:
	for slider in sliders:
		add_slider(slider)

func remove_sliders(sliders: Array[Slider]) -> void:
	for slider in sliders:
		remove_slider(slider)

func _on_button_noises_finished():
	debounce = false
