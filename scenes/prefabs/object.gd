extends RigidBody2D

var is_stickied = false

func _integrate_forces(state):
	if is_stickied and get_parent() is RigidBody2D:
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0
		
		


