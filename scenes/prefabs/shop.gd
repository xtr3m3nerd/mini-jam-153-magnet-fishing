extends Node2D

signal purchased_item(item)

@onready var player : Player = $Player

@export var upgrades : Array[Upgrade] = []
@onready var upgrade_displays = $Control/HBoxContainer.get_children()
var displayed_upgrades = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for upgrade_display in upgrade_displays:
		
		#find which upgrade type and level based on player's current upgrades
		var upgrade_level = 0
		var upgrade_type = Upgrade.Types.LENGTH
		for upgrade in player.upgrades:
			if(upgrade.type == upgrade_display.displayed_upgrade.type):
				upgrade_type = upgrade.type
				
				if(upgrade.level > upgrade_level):
					upgrade_level = upgrade.level
					
		upgrade_level += 1
		
		#find correct upgrade from list, and apply it to upgrade_display
		for upgrade in upgrades:
			if(upgrade.type == upgrade_type and 
			upgrade.level == upgrade_level):
				upgrade_display.displayed_upgrade = upgrade
				upgrade_display.update_display()
				
		
		upgrade_display.disabled = false
		upgrade_display.text.show()



	
	
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func remove_item(item : Upgrade):
	print(item.name)
	
	upgrades.erase(item)
	
	for upgrade_display in upgrade_displays:
		if upgrade_display.displayed_upgrade.type == item.type:
			upgrade_display.disabled = true
			upgrade_display.texture_normal = null
			upgrade_display.text.hide()
	pass

func purchase_item(item : Upgrade):
	if($Player.money >= item.price):
		$Player.upgrades.append(item)
		$Player.money -= item.price
		
		purchased_item.emit(item)
		
		#TODO: Play purchase sound
	else:
		#TODO: Play can't purchase sound
		pass
