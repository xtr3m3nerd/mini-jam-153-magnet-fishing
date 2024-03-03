extends TextureButton

@onready var shop = $"../../.."
@onready var text = $RichTextLabel
@onready var platform: Sprite2D = $Platform

@export var displayed_upgrade : Upgrade


func update_display():
	var format_string = "[center]$%s[/center]"
	text.text = format_string % displayed_upgrade.price
	texture_normal = displayed_upgrade.texture

func _on_pressed():
	shop.purchase_item(displayed_upgrade)


func _on_focus_entered():
	material.set("shader_parameter/HovState",1)
	platform.material.set("shader_parameter/HovState",1)

func _on_focus_exited():
	material.set("shader_parameter/HovState",0)
	platform.material.set("shader_parameter/HovState",0)

func _on_mouse_entered():
	_on_focus_entered()

func _on_mouse_exited():
	_on_focus_exited()

