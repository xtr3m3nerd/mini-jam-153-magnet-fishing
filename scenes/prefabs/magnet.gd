extends RigidBody2D

@export var movement_force = 400
@export var magnetic_strength = 1000
@export var magnetic_stength_curve: Curve
@export var magnetic_curve_range: float = 200.0
@export var spring_tolerance = 4.0
@onready var magnetic_zone: Area2D = $Magnet/MagneticZone

@export var num_springs: int = 1

var is_magnet_active = false

var sticky_pickups = []
var springs = []

func _ready():
	if not magnetic_stength_curve:
		magnetic_stength_curve = Curve.new()

func _input(event):
	if event.is_action_pressed("magnet"):
		is_magnet_active = !is_magnet_active
		if not is_magnet_active:
			unstick_pickups()

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	apply_central_force(Vector2.RIGHT * direction * movement_force)
	
	if Input.is_action_pressed("magnet"):
		for pickup in magnetic_zone.get_overlapping_bodies():
			#if pickup in sticky_pickups:
				#break
			var pickup_distance = pickup.global_position.distance_to(global_position)
			var pull_dir = pickup.global_position.direction_to(global_position).normalized()
			
			var curve_strength = magnetic_stength_curve.sample(clamp(1.0 - pickup_distance/magnetic_curve_range, 0.0, 1.0))
			var force = pull_dir * magnetic_strength * curve_strength  * delta 
			pickup.apply_central_impulse(force)
			apply_central_impulse(-force)
			#apply_force(-force)
		
		var springs_to_remove = []
		for i in springs.size():
			var spring = springs[i]
			var body = get_node(spring.node_b)
			var dist = global_position.distance_to(body.global_position)
			if dist > spring.rest_length * spring_tolerance:
				springs_to_remove.append(spring)
				spring.queue_free()
				if body in sticky_pickups:
					sticky_pickups.erase(body)
		
		for spring in springs_to_remove:
			springs.erase(spring)

func _on_body_entered(body):
	if is_magnet_active and body.is_in_group("pickup") and not body in get_children():
		
		for i in num_springs:
			var spring: DampedSpringJoint2D = DampedSpringJoint2D.new()
			spring.rest_length = global_position.distance_to(body.global_position) / 2.0
			spring.length = spring.rest_length
			spring.stiffness = 64
			add_child(spring)
			spring.node_a = get_path()
			spring.node_b = body.get_path()
			
			springs.append(spring)
		
		sticky_pickups.append(body)

func unstick_pickups():
	for spring in springs:
		spring.queue_free()
		
	sticky_pickups = []
	springs = []
