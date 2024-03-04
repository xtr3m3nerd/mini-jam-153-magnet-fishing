extends Control

@onready var textlabel : Label = $CenterContainer/Label

func _ready():
	ShowCredits()


func ShowCredits():
	#order follows IGDA Game Crediting Guidelines as close as possible
	#if there are corrections to be made, make them
	#note that these guidelines don't normally really apply to jams, or even non-paid work usually...
	#https://drive.google.com/file/d/1jhs6vG3Qieu4tjJ6ImqhZ21_pMHkDLxM/view
	
	await get_tree().create_timer(2).timeout
	ShowCredit("Dakota Thatcher - Technical Artist / Original Concept")
	await get_tree().create_timer(2).timeout
	ShowCredit("Kevin Albregard - Artist: UX")
	await get_tree().create_timer(2).timeout
	ShowCredit("Bailee Grace - Artist: Characters/Environment")
	await get_tree().create_timer(2).timeout
	ShowCredit("Ben Branch - Audio: Composer/SFX/Implementation")
	await get_tree().create_timer(2).timeout
	ShowCredit("Trevor Baughn - Technical Designer")
	await get_tree().create_timer(2).timeout
	ShowCredit("Xavier Vargas - Main Programmer")
	await get_tree().create_timer(2).timeout
	
	SceneManager.change_to_menu()
	pass

func ShowCredit(credit):
	var alpha : float = 0
	textlabel.add_theme_color_override("font_color", Color(1, 1, 1, alpha))
	textlabel.text = credit
	
	$AnimationPlayer.play("fadein")
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("fadeout")
	pass
