extends Control

func _ready():
	update_money_display()
	pass

func update_money_display():
	var format_string = "$%s"
	$DisplayCurrentMoney.text = format_string % PlayerManager.money


func _on_test_shop_purchased_item(item):
	update_money_display()
	pass # Replace with function body.
