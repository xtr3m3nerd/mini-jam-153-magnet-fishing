extends Camera2D

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

@export var max_height : float

const SPEED = 0.75
var target_y

func _process(delta):
	
	target_y = player.global_position.y
	
	if target_y < max_height:
		target_y = max_height
	
	global_position.y = lerpf(global_position.y, target_y, delta * SPEED)
