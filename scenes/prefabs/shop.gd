extends Node2D

signal purchased_item

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

	

func purchase_item(item : Upgrade):
	if($Player.money >= item.price):
		$Player.upgrades.append(item)
		$Player.money -= item.price
		
		purchased_item.emit()
		
		#TODO: Play purchase sound
	else:
		#TODO: Play can't purchase sound
		pass
