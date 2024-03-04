extends Control

@onready var textlabel : RichTextLabel = $CenterContainer/RichTextLabel

func _ready():
	Intro()

func _process(_delta):
	if(Input.is_action_just_pressed("ui_accept")):
		SceneManager.change_to_level()

func Intro():
	
	await get_tree().create_timer(2).timeout
	ShowText("[center]A [color=blue]fish[/color][/center]")
	await get_tree().create_timer(5).timeout

	
	SceneManager.change_to_level()
	pass

func ShowText(text):
	textlabel.modulate = Color(1,1,1,0)
	textlabel.text = text
	
	$AnimationPlayer.play("fadein")
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("fadeout")
	pass
