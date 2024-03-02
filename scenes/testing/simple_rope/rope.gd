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

func _process(delta):
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
	# Check to remove point
	if points.size() >= 2:
		var query = PhysicsRayQueryParameters2D.create(magnet.global_position, points[-2], 1)
		var results = get_world_2d().direct_space_state.intersect_ray(query)
		if results.is_empty():
			remove_point()
	# Check for new collisions
	var query = PhysicsRayQueryParameters2D.create(points[-1], magnet.global_position, 1)
	var results = get_world_2d().direct_space_state.intersect_ray(query)
	if not results.is_empty():
		var pos = results.position
		var bond_pos = Vector2(round_to_multiple_of(pos.x, TILE_SIZE), round_to_multiple_of(pos.y, TILE_SIZE))
		add_point(bond_pos)
		print(str(pos) + " : " + str(bond_pos))

func round_to_multiple_of(number: float, base: float) -> float:
	var remainder = fmod(number, base)
	var result = number - remainder
	if remainder >= base / 2.0:
		result += base
	return result

func update_length(value: float):
	update_anchor(value)

func add_point(point: Vector2):
	points.append(point)
	update_anchor(length)

func remove_point():
	points.remove_at(points.size()-1)
	update_anchor(length)
	
func update_anchor(value):
	var current_length = 0.0
	if points.size() > 1:
		for i in points.size() - 1:
			current_length += points[i].distance_to(points[i+1])
	var remaining_length = length - current_length
	anchor_point.global_position = points[-1]
	damped_spring_joint_2d.rest_length = remaining_length
	damped_spring_joint_2d.node_a = anchor_point.get_path()
	damped_spring_joint_2d.node_b = magnet.get_path()
	
