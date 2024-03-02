extends CharacterBody2D

@onready var mount_point: PinJoint2D = $MountPoint

const SPEED = 20.0
var id := -1
var parent: Node

func add_segment(segment: PhysicsBody2D):
	add_child(segment)
	segment.position = mount_point.position
	mount_point.node_b = mount_point.get_path_to(segment)
	

func _physics_process(delta):
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = input_dir.normalized()
	
	if direction:
		velocity = direction * SPEED
		move_and_slide()
