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
			var pull_dir = object.global_position.direction_to(global_position)
			
			var force = pull_dir * magnetic_strength * delta
			object.apply_force(force)
			
		
		for object in sticky_zone.get_overlapping_bodies():
			if object not in sticky_objects:
				var joint = PinJoint2D.new()
				
				#joint.length = 1.1 * object.global_position.distance_to(self.global_position)
				#joint.rest_length = object.global_position.distance_to(self.global_position)
				#joint.stiffness = 64
				object.add_child(joint)
				
				joint.position = Vector2.ZERO
				
				joint.node_a = object.get_path()
				joint.node_b = get_parent().get_path()
				
				sticky_joints.append(joint)
				sticky_objects.append(object)
			
		

func update_physics():
	if get_parent() is RigidBody2D:
		original_mass = get_parent().mass
		get_parent().mass = mass

	for joint in sticky_joints:
		joint.node_b = get_parent().get_path()
		

func reset_physics():
	if get_parent() is RigidBody2D:
		get_parent().mass = original_mass


