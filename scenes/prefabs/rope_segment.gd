extends RigidBody2D

@onready var mount_point = $MountPoint
@onready var pin_joint_2d = $PinJoint2D

var id := -1
var parent: Node

func attach_to(rope_part: PhysicsBody2D):
	if rope_part.has_node("MountPoint"):
		global_position = rope_part.get_node("MountPoint").global_position
	pin_joint_2d.node_a = rope_part
