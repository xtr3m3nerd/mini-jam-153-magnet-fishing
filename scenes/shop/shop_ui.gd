extends Control

@onready var shop = $".."
@onready var display_current_money = $PanelContainer/MarginContainer/DisplayCurrentMoney

func _ready():
	update_money_display()
	$HBoxContainer/DisplayItem.grab_focus()

func update_money_display():
	var format_string = "$%s"
	display_current_money.text = format_string % PlayerManager.money

func _on_shop_purchased_item(_item):
	update_money_display()

func _on_texture_button_focus_entered():
	$ContinueButton.material.set("shader_parameter/HovState",1)

func _on_texture_button_focus_exited():
	$ContinueButton.material.set("shader_parameter/HovState",0)

func _on_texture_button_mouse_entered():
	_on_texture_button_focus_entered()

func _on_texture_button_mouse_exited():
	_on_texture_button_focus_exited()
