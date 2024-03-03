extends Control

func _ready():
	update_money_display()
	pass

func update_money_display():
	var format_string = "$%s"
	$DisplayCurrentMoney.text = format_string % PlayerManager.money


func _on_test_shop_purchased_item(item):
	update_money_display()
	pass 



func _on_texture_button_focus_entered():
	$ContinueButton.material.set("shader_parameter/HovState",1)
	pass
func _on_texture_button_focus_exited():
	$ContinueButton.material.set("shader_parameter/HovState",0)
	pass 


func _on_texture_button_mouse_entered():
	_on_texture_button_focus_entered()
	pass 
func _on_texture_button_mouse_exited():
	_on_texture_button_focus_exited()
	pass

