extends TextureButton
class_name WebTextureButton

@export var link = ""

func _ready():
	pressed.connect(goto_link)

func goto_link():
	OS.shell_open(link)
