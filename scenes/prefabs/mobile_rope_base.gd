extends CharacterBody2D

@onready var mount_point: PinJoint2D = $MountPoint

var id := -1
var parent: Node

func add_segment(segment: PhysicsBody2D):
	add_child(segment)
	segment.position = mount_point.position
	mount_point.node_b = mount_point.get_path_to(segment)
