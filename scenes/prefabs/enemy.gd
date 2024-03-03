extends CharacterBody2D

@onready var collision_shape_2d = $CollisionShape2D
@onready var latch_check_ray = $LatchCheckRay
@onready var graphics = $Graphics

@export var move_speed: float = 75.0
@export var chase_speed: float = 150.0
@export var move_acceleration: float = 125.0
@export var chase_acceleration: float = 100.0
@export var dist_tolerance: float = 10.0
@export var damping: float = 0.1

@export var explore_path: Line2D
var path: PackedVector2Array = []
var path_idx = -1

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var state_label = $StateLabel
@onready var target_locator = $TargetLocator

enum EnemyStates {
	IDLE,
	PATROL,
	CHASE,
	LATCHED,
}
var current_state = EnemyStates.IDLE
var flipped = false

func _ready():
	if explore_path:
		for pos in explore_path.points:
			path.append(pos + explore_path.global_position)
	else:
		path.append(global_position)
	change_state(EnemyStates.IDLE)
	$Line2D.global_position = Vector2.ZERO
	$Line2D.points = path
	$Line2D.reparent(get_tree().current_scene)
	
func _process(delta):
	target_locator.global_position = path[path_idx]

func _physics_process(delta):
	match current_state:
		EnemyStates.IDLE:
			idle(delta)
		EnemyStates.PATROL:
			patrol(delta)
		EnemyStates.CHASE:
			chase(delta)
		EnemyStates.LATCHED:
			idle(delta)
	
	move_and_slide()

func idle(delta):
	velocity *= pow(damping, delta)

func patrol(delta):
	move_towards_point(delta, path[path_idx], move_speed, move_acceleration)
	if path[path_idx].distance_to(global_position) < dist_tolerance:
		change_state(EnemyStates.IDLE)

func chase(delta):
	move_towards_point(delta, player.global_position - Vector2.UP * 23.0, chase_speed, chase_acceleration)
	attempt_to_latch_to_player()

func move_towards_point(delta: float, point: Vector2, speed: float, acceleration: float):
	var dir = point - global_position
	dir = dir.normalized()
	dir.y *= 4.0
	dir *= acceleration
	velocity += dir * delta
	if velocity.length() > move_speed:
		velocity = velocity.normalized() * move_speed
	correct_direction()

func correct_direction():
	if !flipped and velocity.x < 0:
		flipped = true
		latch_check_ray.target_position.x *= -1.0
		graphics.scale.x *= -1.0
	elif flipped and velocity.x > 0:
		flipped = false
		latch_check_ray.target_position.x *= -1.0
		graphics.scale.x *= -1.0

func attempt_to_latch_to_player():
	if latch_check_ray.is_colliding():
		change_state(EnemyStates.LATCHED)

func _on_idle_timer_timeout():
	change_state(EnemyStates.PATROL)

func change_state(new_state: EnemyStates):
	$IdleTimer.stop()
	match new_state:
		EnemyStates.IDLE:
			$IdleTimer.start()
			state_label.text = "IDLE"
		EnemyStates.PATROL:
			path_idx = (path_idx + 1) % path.size()
			state_label.text = "PATROL"
		EnemyStates.CHASE:
			state_label.text = "CHASE"
			pass
		EnemyStates.LATCHED:
			state_label.text = "LATCHED"
			pass
	current_state = new_state
