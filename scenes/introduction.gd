extends Control

@onready var textlabel : Label = $CenterContainer/Label

func _ready():
	Intro()


func Intro():
	
	await get_tree().create_timer(2).timeout
	ShowText("Dakota Thatcher - Technical Artist / Original Concept")
	await get_tree().create_timer(5).timeout
	ShowText("Kevin Albregard - Artist")
	await get_tree().create_timer(5).timeout
	ShowText("Bailee Grace - Artist")
	await get_tree().create_timer(5).timeout
	ShowText("Ben Branch - Audio")
	await get_tree().create_timer(5).timeout
	ShowText("Trevor Baughn - Technical Designer")
	await get_tree().create_timer(5).timeout
	ShowText("Xavier Vargas - Programmer")
	
	SceneManager.change_to_menu()
	pass

func ShowText(text):
	var alpha : float = 0
	textlabel.add_theme_color_override("font_color", Color(1, 1, 1, alpha))
	textlabel.text = text
	
	$AnimationPlayer.play("fadein")
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("fadeout")
	pass
