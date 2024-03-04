extends Node

@export var main_menu_scene: PackedScene
@export var level_scene: PackedScene
@export var shop_scene: PackedScene
@export var credits_scene: PackedScene
@export var intro_scene: PackedScene

func change_to_menu():
	get_tree().change_scene_to_packed(main_menu_scene)
	
func change_to_level():
	get_tree().change_scene_to_packed(level_scene)

func change_to_shop():
	get_tree().change_scene_to_packed(shop_scene)
	
func change_to_credits():
	get_tree().change_scene_to_packed(credits_scene)
