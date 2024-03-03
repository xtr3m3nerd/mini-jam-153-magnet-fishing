class_name PendulumBody2D
extends CharacterBody2D
 
@export var anchor: Vector2 = Vector2.ZERO
@export var length_speed: float = 50.0
@export var move_speed: float = 100
@export var damping: float = 0.9
@export var mass: float = 1.0

var length := 1.0
var angle := 0.0
var angular_velocity := 0.0
var angular_accelleration := 0.0
var angular_momentum := 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	length = anchor.distance_to(global_position)
	angular_momentum = mass * angular_velocity * length

func _process(delta):
	var change = Input.get_axis("move_up", "move_down")
	length += change * length_speed * delta
	angular_velocity = angular_momentum / (mass * length)

func _physics_process(delta):
	angle = -PI/2 + atan2(global_position.y - anchor.y, global_position.x - anchor.x)
	angular_accelleration = gravity * sin(angle)
	angular_velocity += angular_accelleration * delta
	angular_velocity *= pow(damping, delta)
	
	var old_velocity = angular_velocity
	var direction = Input.get_axis("move_left", "move_right")
	angular_velocity += direction * move_speed * delta
	angular_momentum = mass * angular_velocity * length
	
	var temp_velocity = Vector2(
		angular_velocity * cos(angle),
		angular_velocity * sin(angle))
	
	var new_pos = Vector2(
		global_position.x + temp_velocity.x * delta,
		global_position.y + temp_velocity.y * delta)
	
	var vector = new_pos - anchor
	vector = vector.normalized() * length
	var corrected_pos = anchor + vector
	
	var check_velocity = corrected_pos - global_position
	velocity = check_velocity / delta
	
	var collision := move_and_collide(velocity * delta)
	
	if collision:
		angular_velocity = 0.0
		angular_momentum = 0.0
	
	var corrected_length = global_position.distance_to(anchor)
	length = corrected_length
	rotation = angle

func update_anchor(new_anchor: Vector2):
	anchor = new_anchor
	length = global_position.distance_to(new_anchor)

func set_starting(new_anchor: Vector2, pos: Vector2):
	anchor = new_anchor
	global_position = pos
	length = anchor.distance_to(global_position)
	angular_velocity = 0.0
	angular_momentum = 0.0
