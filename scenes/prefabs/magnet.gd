extends RigidBody2D

@export var FORCE = 400
@export var magnetic_strength = 100000
@export var spring_tolerance = 4.0
@onready var magnetic_zone: Area2D = $MagneticZone
@onready var sticky_zone: Area2D = $StickyZone
var is_magnet_active = false

var sticky_objects = []
var springs = []

func _input(event):
	if event.is_action_pressed("magnet"):
		is_magnet_active = !is_magnet_active
	
		if not is_magnet_active:
			unstick_objects()

func _physics_process(delta):
	
	var direction = Input.get_axis("move_left", "move_right")
	apply_central_force(Vector2.RIGHT * direction * FORCE)
	
	print(sticky_objects)
	
	if is_magnet_active:
		for object in magnetic_zone.get_overlapping_bodies():
			if object not in sticky_objects:
				var pull_dir = object.global_position.direction_to(global_position)
				
				var force = pull_dir * magnetic_strength * delta
				object.apply_force(force)
		
		var springs_to_remove = []
		for i in springs.size():
			var spring = springs[i]
			var body = get_node(spring.node_b)
			var dist = global_position.distance_to(body.global_position)
			if dist > spring.rest_length * spring_tolerance:
				springs_to_remove.append(spring)
				spring.queue_free()
				if body in sticky_objects:
					sticky_objects.erase(body)
		
		for spring in springs_to_remove:
			springs.erase(spring)

func _on_body_entered(body):
	if is_magnet_active and body.is_in_group("object") and not body in get_children():
		
		var spring: DampedSpringJoint2D = DampedSpringJoint2D.new()
		spring.rest_length = global_position.distance_to(body.global_position) / 2.0
		spring.length = spring.rest_length
		spring.stiffness = 64
		add_child(spring)
		spring.node_a = get_path()
		spring.node_b = body.get_path()
		
		sticky_objects.append(body)
		springs.append(spring)


func unstick_objects():
	for spring in springs:
		spring.queue_free()
		
	sticky_objects = []
	springs = []
