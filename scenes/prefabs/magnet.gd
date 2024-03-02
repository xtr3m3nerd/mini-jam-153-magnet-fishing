extends Node2D

@export var FORCE = 400
@export var magnetic_strength = 100000
@onready var magnetic_zone: Area2D = $MagneticZone
@onready var sticky_zone: Area2D = $StickyZone
var is_magnet_active = false

var sticky_objects = []
var sticky_colliders = []
var original_sticky_colliders = []

func _input(event):
	if event.is_action_pressed("magnet"):
		is_magnet_active = !is_magnet_active
		
		if not is_magnet_active:
			ungrab_objects()

func _physics_process(delta):
	
	var direction = Input.get_axis("move_left", "move_right")
	if get_parent() is RigidBody2D:
		get_parent().apply_central_force(Vector2.RIGHT * direction * FORCE)
	
	print(sticky_objects)
	
	if is_magnet_active:
		for object in magnetic_zone.get_overlapping_bodies():
			if object not in sticky_objects:
				var pull_dir = object.global_position.direction_to(global_position)
				
				var force = pull_dir * magnetic_strength * delta
				object.apply_force(force)
			
		
		for object in sticky_zone.get_overlapping_bodies():
			if object not in sticky_objects:
			
				var sticky = object.get_node("StickyZone")
				
				var sticky_addition = sticky.duplicate()
				sticky.get_node("CollisionShape2D").disabled = true
				
				sticky_zone.add_child(sticky_addition)
				sticky_addition.global_position = object.position
				
				var object_pos = object.position
				object.get_parent().remove_child(object)
				self.add_child(object)
				object.global_position = object_pos
				object.get_node("CollisionShape2D").disabled = false
				object.sleeping = true
				object.gravity_scale = 0
				object.is_stickied = true

				original_sticky_colliders.append(sticky)
				sticky_colliders.append(sticky_addition)
				sticky_objects.append(object)
			

func ungrab_objects():
	for sticky_collider in sticky_colliders:
		sticky_collider.queue_free()
		
	for sticky in original_sticky_colliders:
		sticky.get_node("CollisionShape2D").disabled = false
		
	
	for object in sticky_objects:
		object.get_node("CollisionShape2D").disabled = false
		object.sleeping = false
		object.gravity_scale = 1
		object.freeze = false
		object.is_stickied = false
		
		var object_pos = object.global_position
		remove_child(object)
		get_parent().get_parent().add_child(object)
		object.global_position = object_pos
	
	sticky_objects = []
	sticky_colliders = []
	original_sticky_colliders = []



