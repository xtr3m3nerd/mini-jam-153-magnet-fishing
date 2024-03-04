extends Control

@onready var textlabel : RichTextLabel = $CenterContainer/RichTextLabel

func _ready():
	Intro()

func _process(_delta):
	if(Input.is_action_just_pressed("ui_accept")):
		SceneManager.change_to_level()

func Intro():
	
	await get_tree().create_timer(2).timeout
	ShowText("[center]A [color=aqua]fish[/color]...[/center]", 3)
	await get_tree().create_timer(5).timeout
	ShowText("[center][shake rate=20.0 level=5 connected=1][color=yellow]Goldy[/color][/shake][/center]", 5)
	await get_tree().create_timer(7).timeout
	ShowText("[center][color=yellow]Goldy[/color] runs out into the dangers of space...[p align=center]Searching for an [color=cyan]exotic matter[/color], known only as...[/p][/center]", 3)
	await get_tree().create_timer(5).timeout
	ShowText("[center][wave amp=50.0 freq=5.0 connected=1][color=cyan]~ Waterium ~[/color][/wave][/center]", 5)
	await get_tree().create_timer(7).timeout
	ShowText("[center][color=cyan]Waterium[/color] has been found on a nearby asteroid...[/center]", 3)
	await get_tree().create_timer(5).timeout
	ShowText("[center]But it's [color=orange]dangerous[/color] for fish-kind to venture into the depths[p align=center]where the [wave amp=50.0 freq=5.0 connected=1][color=cyan]elusive nectar[/color][/wave] can be found...[/p][/center]", 5)
	await get_tree().create_timer(7).timeout
	ShowText("[center]So [color=yellow]Goldy[/color] ventured forth with a [color=red]heat-resistant[/color] [color=blue]magnet[/color]...[/center]", 3)
	await get_tree().create_timer(5).timeout
	
	SceneManager.change_to_level()
	pass

func ShowText(text, show_time : float):
	textlabel.modulate = Color(1,1,1,0)
	textlabel.text = text
	
	$AnimationPlayer.play("fadein")
	await get_tree().create_timer(show_time).timeout
	$AnimationPlayer.play("fadeout")
	pass
