extends Node2D

@export var FORCE = 400
@export var mass = 2.0
@export var magnetic_strength = 100000
var original_mass = 0
@onready var magnetic_zone: Area2D = $MagneticZone

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if get_parent() is RigidBody2D:
		get_parent().apply_central_force(Vector2.RIGHT * direction * FORCE)
	
	if Input.is_action_pressed("magnet"):
		for object in magnetic_zone.get_overlapping_bodies():
			var pull_dir = object.global_position.direction_to(global_position)
			
			var force = pull_dir * magnetic_strength * delta
			object.apply_force(force)

func update_physics():
	if get_parent() is RigidBody2D:
		original_mass = get_parent().mass
		get_parent().mass = mass

func reset_physics():
	if get_parent() is RigidBody2D:
		get_parent().mass = original_mass
