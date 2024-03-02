extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	update_money_display()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update_money_display():
	var format_string = "$%s"
	$Control/DisplayCurrentMoney.text = format_string % $Player.money
	

func purchase_item(item : Upgrade):
	if($Player.money >= item.price):
		$Player.upgrades.add_item(item)
		$Player.money -= item.price
		update_money_display()
		
		#TODO: Play purchase sound
	else:
		#TODO: Play can't purchase sound
		pass
