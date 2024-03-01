extends RigidBody2D

@export var FORCE = 400

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	apply_central_force(Vector2.RIGHT * direction * FORCE)
