extends RigidBody2D


@onready var mount_point = $MountPoint
@onready var spawn_detection: Area2D = $SpawnDetection

var id := -1
var parent: Node

func add_segment(segment: PhysicsBody2D):
	add_child(segment)
	segment.position = mount_point.position
	mount_point.node_a = ".."
	mount_point.node_b = mount_point.get_path_to(segment)

func remove_self():
	if get_parent().mount_point:
		get_parent().mount_point.node_b = NodePath("")
	get_parent().remove_child(self)
	queue_free()

func can_add_segment() -> bool:
	if spawn_detection.get_overlapping_bodies().size() > 0:
		return false
	return true
