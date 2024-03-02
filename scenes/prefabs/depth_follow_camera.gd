extends Camera2D

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

const SPEED = 0.5

func _process(delta):
	global_position.y = lerpf(global_position.y, player.global_position.y, delta * SPEED)
