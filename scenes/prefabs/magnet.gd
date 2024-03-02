extends Node2D

@export var FORCE = 400
@export var mass = 2.0
@export var magnetic_strength = 100000
var original_mass = 0
@onready var magnetic_zone: Area2D = $MagneticZone
@onready var sticky_zone: Area2D = $StickyZone
var is_magnet_active = false

var sticky_joints = []
var sticky_objects = []
var sticky_colliders = []
var original_sticky_colliders = []

func _input(event):
	if event.is_action_pressed("magnet"):
		is_magnet_active = !is_magnet_active



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
				#var joint = DampedSpringJoint2D.new()
				#
				#joint.length = 1.1 * object.global_position.distance_to(self.global_position)
				#joint.rest_length = object.global_position.distance_to(self.global_position)
				#joint.stiffness = 64
				#object.add_child(joint)
				#
				#joint.position = Vector2.ZERO
				#
				#joint.node_a = object.get_path()
				#joint.node_b = self.get_path()
				
				var sticky = object.get_node("StickyZone")
				
				var sticky_addition = sticky.duplicate()
				sticky.get_node("CollisionShape2D").disabled = true
				
				sticky_zone.add_child(sticky_addition)
				sticky_addition.global_position = object.position
				
				object.get_parent().remove_child(object)
				self.add_child(object)
				object.get_node("CollisionShape2D").disabled = true
				object.sleeping = true
				object.gravity_scale = 0
				object.is_stickied = true
				object.freeze = true
				
				
				
				#sticky_joints.append(joint)
				original_sticky_colliders.append(sticky)
				sticky_colliders.append(sticky_addition)
				sticky_objects.append(object)
			
	else:
		#for joint in sticky_joints:
		#	joint.queue_free()
		for sticky_collider in sticky_colliders:
			sticky_collider.queue_free()
			
		for sticky in original_sticky_colliders:
			sticky.get_node("CollisionShape2D").disabled = false
			
		
		for object in sticky_objects:
			object.get_node("CollisionShape2D").disabled = false
			object.sleeping = false
			object.gravity_scale = 1
			object.freeze = false
		
		#sticky_joints = []
		sticky_objects = []
		sticky_colliders = []
		original_sticky_colliders = []

func update_physics():
	if get_parent() is RigidBody2D:
		original_mass = get_parent().mass
		get_parent().mass = mass

	#for joint in sticky_joints:
		#joint.node_b = get_parent().get_path()
		

func reset_physics():
	if get_parent() is RigidBody2D:
		get_parent().mass = original_mass


