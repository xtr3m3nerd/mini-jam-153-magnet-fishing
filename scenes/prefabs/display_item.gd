extends TextureButton

@export var displayed_upgrade : Upgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	var format_string = "[center]$%s[/center]"
	$RichTextLabel.text = format_string % displayed_upgrade.price
	
	texture_normal = displayed_upgrade.texture
	pass # Replace with function body.

func _on_pressed():
	print("Test")
	
	pass # Replace with function body.

func _on_mouse_entered():
	material.set("shader_parameter/HovState",1)
	pass # Replace with function body.


func _on_mouse_exited():
	material.set("shader_parameter/HovState",0)
	pass # Replace with function body.
