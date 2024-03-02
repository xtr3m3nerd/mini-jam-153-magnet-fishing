extends Node2D

const TILE_SIZE = 32

@export var grow_speed = 50.0
@export var length = 64.0:
	set(value):
		if value != length:
			length = value
			update_length(value)

var points: PackedVector2Array = []

@onready var damped_spring_joint_2d = $AnchorPoint/DampedSpringJoint2D
@onready var anchor_point = $AnchorPoint
@onready var magnet = $FloatingMagnet
@onready var line_2d = $Line2D

func _ready():
	points.append(global_position)
	update_length(length)

func _process(_delta):
	var all_points = points.duplicate()
	all_points.append(magnet.global_position)
	for i in all_points.size():
		all_points[i] = all_points[i] - global_position
	line_2d.points = all_points

func _physics_process(delta):
	var direction = Input.get_axis("move_up", "move_down")
	length += direction * grow_speed * delta
	
	if points.size() < 1:
		return
	
	# Check if object is no longer in the way of magnet and previous point
	if points.size() >= 2:
		if ray_collision_check(magnet.global_position, points[-2]).is_empty():
			remove_point()
	
	# Check for collision between last point and the magnet
	var results = ray_collision_check(points[-1], magnet.global_position)
	if results.is_empty():
		#Check backwards to see if line is colliding back into the same object
		var back_results = ray_collision_check(magnet.global_position, points[-1])
		if not back_results.is_empty() and back_results.position != points[-1]:
			find_point_to_add(back_results.position)
	else:
		find_point_to_add(results.position)

func ray_collision_check(from: Vector2, to: Vector2):
	var query = PhysicsRayQueryParameters2D.create(from, to, 1)
	var results = get_world_2d().direct_space_state.intersect_ray(query)
	return results

func find_point_to_add(pos: Vector2):
	var point_to_add = pos
	var check_points = []
	var remainder = Vector2(fmod(pos.x, TILE_SIZE), fmod(pos.y, TILE_SIZE))
	
	# only look at points accross collision plane to find best match
	if remainder.x == 0 and remainder.y != 0:
		check_points.append(Vector2(pos.x, pos.y-remainder.y))
		check_points.append(Vector2(pos.x, pos.y-remainder.y+TILE_SIZE))
	elif remainder.y == 0 and remainder.x != 0:
		check_points.append(Vector2(pos.x-remainder.x, pos.y))
		check_points.append(Vector2(pos.x-remainder.x+TILE_SIZE, pos.y))
	
	# prioritize the closest points
	var sorted_check_points = sort_by_closeness(check_points, pos)
	
	for point in sorted_check_points:
		var results = ray_collision_check(magnet.global_position, point)
		# if their are no extra collisions use the point
		if results.is_empty() or results.position == point:
			point_to_add = point
			break
	
	add_point(point_to_add)

func sort_by_closeness(array: Array, pos: Vector2) -> Array:
	array.sort_custom(func(a, b): return (a - pos).length_squared() < (b - pos).length_squared())
	return array

func update_length(_value: float):
	update_anchor()

func add_point(point: Vector2):
	points.append(point)
	update_anchor()

func remove_point():
	points.remove_at(points.size()-1)
	update_anchor()
	
func update_anchor():
	var current_length = 0.0
	if points.size() > 1:
		for i in points.size() - 1:
			current_length += points[i].distance_to(points[i+1])
	var remaining_length = length - current_length
	# adjust anchor spring by remaining length
	anchor_point.global_position = points[-1]
	damped_spring_joint_2d.rest_length = remaining_length
	damped_spring_joint_2d.node_a = anchor_point.get_path()
	damped_spring_joint_2d.node_b = magnet.get_path()
	
