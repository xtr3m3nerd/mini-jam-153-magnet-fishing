extends Control

signal purchased_item(item)

@export var upgrades : Array[Upgrade] = []
@onready var upgrade_displays = $Control/HBoxContainer.get_children()
var displayed_upgrades = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for upgrade_display in upgrade_displays:
		
		#find which upgrade type and level based on player's current upgrades
		var type = upgrade_display.displayed_upgrade.type
		var level = upgrade_display.displayed_upgrade.level
		
		
		for upgrade in PlayerManager.upgrades:
			if(upgrade.type == type):
				if(upgrade.level > level):
					level = upgrade.level
		
		level += 1
		
		#find correct upgrade from list, and apply it to upgrade_display
		var new_upgrade = null
		for upgrade in upgrades:
			if upgrade.type == type and upgrade.level == level:
				new_upgrade = upgrade
				break
		
		if new_upgrade != null:
			upgrade_display.displayed_upgrade = new_upgrade
			upgrade_display.update_display()
			upgrade_display.disabled = false
			upgrade_display.text.show()
		else:
			upgrade_display.disabled = true
			upgrade_display.texture_normal = null
			upgrade_display.text.hide()


func remove_item(item : Upgrade):
	#upgrades.erase(item)
	
	for upgrade_display in upgrade_displays:
		if upgrade_display.displayed_upgrade.type == item.type:
			upgrade_display.disabled = true
			upgrade_display.texture_normal = null
			upgrade_display.text.hide()


	pass

func purchase_item(item : Upgrade):
	if(PlayerManager.money >= item.price):
		PlayerManager.upgrades.append(item)
		PlayerManager.money -= item.price
		
		purchased_item.emit(item)
		
		#TODO: Play purchase sound
	else:
		#TODO: Play can't purchase sound
		pass


func _on_continue_button_pressed():
	SceneManager.change_to_level()
