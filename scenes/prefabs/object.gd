extends RigidBody2D

var is_stickied = false

func _integrate_forces(state):
	if is_stickied and get_parent() is RigidBody2D:
		state.linear_velocity = linear_velocity + get_parent().velocity_vector

		
