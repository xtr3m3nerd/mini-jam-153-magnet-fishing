extends Node2D

@export var segment_prefab: PackedScene = preload("res://scenes/prefabs/rope_segment.tscn")

@export var grow_speed = 50.0
@export var length = 64.0:
	set(value):
		if value != length:
			length = value
			update_length(value)
@export var segment_length = 16.0

@onready var rope_base = $MobileRopeBase
@onready var end_of_rope = $FloatingMagnet
@onready var end_of_rope_pos_spring = $DampedSpringJoint2D


var segments = []
var current_num_segments = 0
var last_point = null
	
func _ready():
	last_point = rope_base
	update_length(length)

func _physics_process(delta):
	var direction = Input.get_axis("move_up", "move_down")
	length += direction * grow_speed * delta

func update_length(value: float):
	if last_point == null:
		return
	var num_segments = ceil(length / segment_length)
	var partial_dist = fmod(length, segment_length)
	#end_of_rope.reset_physics()
	end_of_rope.get_parent().remove_child(end_of_rope)
	
	# Remove extra segments
	if segments.size() > num_segments:
		while segments.size() > num_segments:
			var segment = segments.pop_back()
			segment.remove_self()
		if segments.size() > 0:
			last_point = segments[segments.size()-1]
	
	if segments.size() < num_segments:
		var num_to_add = num_segments - segments.size()
		for i in num_to_add:
			#if last_point.has_method("can_add_segment") and not last_point.can_add_segment():
				#last_point.add_child(end_of_rope)
				#length = segments.size() * segment_length
				#break
			var segment = segment_prefab.instantiate()
			segments.append(segment)
			last_point.add_segment(segment)
			last_point = segment
	
	last_point.add_child(end_of_rope)
	end_of_rope_pos_spring.get_parent().remove_child(end_of_rope_pos_spring)
	last_point.add_child(end_of_rope_pos_spring)
	end_of_rope_pos_spring.position = Vector2.DOWN * partial_dist
	end_of_rope_pos_spring.node_a = last_point.get_path()
	end_of_rope_pos_spring.node_b = end_of_rope.get_path()
	#end_of_rope.position = Vector2.DOWN * partial_dist
	#end_of_rope.update_physics()
			
	$CanvasLayer/Length.text = str(value)
	#last_point.add_segment(end_of_rope)
