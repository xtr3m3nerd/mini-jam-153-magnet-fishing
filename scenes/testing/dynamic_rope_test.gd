extends Node2D

@export var num_of_segments = 10
@export var segment_prefab: PackedScene = preload("res://scenes/prefabs/rope_segment.tscn")
@export var end_of_rope_prefab: PackedScene = preload("res://scenes/prefabs/magnet.tscn")

@onready var rope_base = $MobileRopeBase

func _ready():
	var last_point = rope_base
	for i in num_of_segments:
		var segment = segment_prefab.instantiate()
		add_child(segment)
		segment.attach_to(last_point)
		last_point = segment
	var end_of_rope = end_of_rope_prefab.instantiate()
	add_child(end_of_rope)
	var pin_joint = PinJoint2D.new()
	add_child(pin_joint)
	pin_joint.global_position = last_point.get_node("MountPoint").global_position
	pin_joint.node_a = last_point
	pin_joint.node_b = end_of_rope
