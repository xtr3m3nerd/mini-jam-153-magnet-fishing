extends Node2D

const TILE_SIZE = 32

var points: PackedVector2Array = []
var last_shape: PackedVector2Array = []

@onready var line_2d = $Line2D
@onready var magnet = $Magnet
@onready var collision_shape_2d = $UnstickChecker/CollisionShape2D
@onready var unstick_checker = $UnstickChecker

func _ready():
	points.append(global_position)
	magnet.set_starting(global_position, magnet.global_position)

func _process(_delta):
	# Set the points for the line visuals
	var all_points = points.duplicate()
	all_points.append(magnet.global_position)
	for i in all_points.size():
		all_points[i] = all_points[i] - global_position
	line_2d.points = all_points
	
	last_shape.clear()
	if all_points.size() > 2:
		last_shape.append(all_points[-1])
		last_shape.append(all_points[-2])
		last_shape.append(all_points[-3])
		collision_shape_2d.shape.points = last_shape
	else:
		collision_shape_2d.shape.points = []

func _physics_process(_delta):
	if points.size() < 1:
		return
	
	# Check if object is no longer in the way of magnet and previous point
	if points.size() >= 2 and not last_shape.is_empty():
		var result = ray_collision_check(magnet.global_position, points[-2])
		if result.is_empty() or result.position == points[-2]:
			if unstick_checker.get_overlapping_bodies().is_empty():
				remove_point()

	# Check for collision between last point and the magnet
	var results = ray_collision_check(points[-1], magnet.global_position)
	if results.is_empty():
		#Check backwards to see if line is colliding back into the same object
		var back_results = ray_collision_check(magnet.global_position, points[-1])
		if not back_results.is_empty() and back_results.position != points[-1]:
			find_point_to_add(back_results.position)
	elif results.position != points[-1]:
		find_point_to_add(results.position)

func ray_collision_check(from: Vector2, to: Vector2):
	var query = PhysicsRayQueryParameters2D.create(from, to, 1)
	var results = get_world_2d().direct_space_state.intersect_ray(query)
	return results

func find_point_to_add(pos: Vector2):
	var point_to_add = null
	var check_points = []
	var remainder = Vector2(fmod(pos.x, TILE_SIZE), fmod(pos.y, TILE_SIZE))
	
	# only look at points accross collision plane to find best match
	if remainder.x == 0 and remainder.y != 0:
		check_points.append(Vector2(int(pos.x), int(pos.y-remainder.y)))
		check_points.append(Vector2(int(pos.x), int(pos.y-remainder.y+TILE_SIZE)))
	elif remainder.y == 0 and remainder.x != 0:
		check_points.append(Vector2(int(pos.x-remainder.x), int(pos.y)))
		check_points.append(Vector2(int(pos.x-remainder.x+TILE_SIZE), int(pos.y)))
	
	# prioritize the closest points
	var sorted_check_points = sort_by_closeness(check_points, pos)
	
	var data = []
	for point in sorted_check_points:
		if points[-1].distance_to(point) < 8.0:
			continue
		var dir = point.direction_to(magnet.global_position).normalized()
		var results = ray_collision_check(point + dir * TILE_SIZE, point)
		# if their are no extra collisions use the point
		data.append(results)
		if results.is_empty() or results.position == point:
			point_to_add = point
			break
	
	if point_to_add == null:
		printerr("Cannot find point near tile")
	else:
		add_point(point_to_add)

func sort_by_closeness(array: Array, pos: Vector2) -> Array:
	array.sort_custom(func(a, b): return (a - pos).length_squared() < (b - pos).length_squared())
	return array

func add_point(point: Vector2):
	var check_array = [
		Vector2.UP + Vector2.LEFT,
		Vector2.UP + Vector2.RIGHT,
		Vector2.DOWN + Vector2.RIGHT,
		Vector2.DOWN + Vector2.LEFT,
	]
	var results = []
	for check in check_array:
		var query = PhysicsPointQueryParameters2D.new()
		query.collision_mask = 1
		query.position = point + check
		results.append(get_world_2d().direct_space_state.intersect_point(query))
	
	var check_point = Vector2.ZERO
	for i in results.size():
		if results[i]:
			check_point += check_array[(i + 2) % check_array.size()]
	if check_point == Vector2.ZERO:
		printerr("Point failed: " + str(point))
	else:
		points.append(point + check_point)
		update_anchor()

func remove_point():
	points.remove_at(points.size()-1)
	update_anchor()
	
func update_anchor():
	magnet.update_anchor(points[-1])
