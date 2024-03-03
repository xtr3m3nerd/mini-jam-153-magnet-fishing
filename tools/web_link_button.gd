extends LinkButton
class_name WebLinkButton

@export var use_text_as_link = false

func _ready():
	pressed.connect(goto_link)

func goto_link():
	if use_text_as_link:
		OS.shell_open(text)
	else:
		OS.shell_open(uri)
