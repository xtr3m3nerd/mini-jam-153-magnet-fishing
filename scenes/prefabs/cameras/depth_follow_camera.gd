extends Camera2D

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

@export var max_height : float

const SPEED = 1.5
var target

func _process(delta):
	
	target = player.global_position
	
	if target.y < max_height:
		target.y = max_height
	
	global_position = global_position.lerp(target, delta * SPEED)
