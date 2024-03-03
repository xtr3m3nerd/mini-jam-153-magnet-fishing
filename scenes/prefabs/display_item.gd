extends TextureButton

@onready var shop = $"../../.."
@onready var text = $RichTextLabel

@export var displayed_upgrade : Upgrade



# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
	
func update_display():
	var format_string = "[center]$%s[/center]"
	text.text = format_string % displayed_upgrade.price
	
	texture_normal = displayed_upgrade.texture

func _on_pressed():
	
	shop.purchase_item(displayed_upgrade)
	
	pass 


func _on_focus_entered():
	material.set("shader_parameter/HovState",1)
	pass

func _on_focus_exited():
	material.set("shader_parameter/HovState",0)
	pass



func _on_mouse_entered():
	_on_focus_entered()
	pass
func _on_mouse_exited():
	_on_focus_exited()
	pass
