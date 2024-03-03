extends CharacterBody2D

@onready var latch_check_ray = $LatchCheckRay
@onready var graphics = $Graphics

@export var move_speed: float = 75.0
@export var move_acceleration: float = 125.0

@export var chase_speed: float = 150.0
@export var chase_acceleration: float = 100.0

@export var dist_tolerance: float = 10.0
@export var damping: float = 0.01

@export var explore_path: Line2D
var path: PackedVector2Array = []
var path_idx = -1

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
@onready var state_label = $StateLabel
@onready var vision = $Vision

@onready var out_of_sight_timer: Timer = $OutOfSightTimer
@onready var idle_timer: Timer = $IdleTimer
@export var patrol_wait_time = 0.1

@export var wait_points: Dictionary = {}

# Debug tool
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
	player.attract.connect(_on_magnetic_zone_attract)
	player.detach.connect(_on_magnetic_zone_detach)

func _process(_delta):
	target_locator.global_position = path[path_idx]
	if Input.is_action_just_pressed("test_chase"):
		change_state(EnemyStates.CHASE)

func _physics_process(delta):
	match current_state:
		EnemyStates.IDLE:
			idle(delta)
		EnemyStates.PATROL:
			patrol(delta)
		EnemyStates.CHASE:
			chase(delta)
		EnemyStates.LATCHED:
			latched(delta)
	
	move_and_slide()

func idle(delta):
	if player.magnetic_zone.is_magnet_active and can_see_player():
		return change_state(EnemyStates.CHASE)
	velocity *= pow(damping, delta)

func patrol(delta):
	if player.magnetic_zone.is_magnet_active and can_see_player():
		return change_state(EnemyStates.CHASE)
	move_towards_point(delta, path[path_idx], move_speed, move_acceleration)
	if path[path_idx].distance_to(global_position) < dist_tolerance:
		change_state(EnemyStates.IDLE)

func chase(delta):
	var player_seen = can_see_player()
	if out_of_sight_timer.is_stopped() and not player_seen:
		out_of_sight_timer.start()
	if not out_of_sight_timer.is_stopped() and player_seen:
		out_of_sight_timer.stop()
	move_towards_point(delta, player.global_position - Vector2.UP * 23.0, chase_speed, chase_acceleration)
	attempt_to_latch_to_player()

func latched(delta):
	velocity = player.velocity
	if not latch_check_ray.is_colliding():
		move_towards_point(delta, player.global_position - Vector2.UP * 23.0, chase_speed, chase_acceleration)
	
func move_towards_point(delta: float, point: Vector2, speed: float, acceleration: float):
	var dir = point - global_position
	dir = dir.normalized()
	dir.y *= 4.0
	dir *= acceleration
	velocity += dir * delta
	if velocity.length() > speed:
		velocity = velocity.normalized() * speed
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

func _on_out_of_sight_timer_timeout():
	change_state(EnemyStates.IDLE)

func change_state(new_state: EnemyStates):
	idle_timer.stop()
	match new_state:
		EnemyStates.IDLE:
			if current_state == EnemyStates.PATROL:
				var time = patrol_wait_time
				if wait_points.has(path_idx):
					time = wait_points[path_idx]
				idle_timer.start(time)
			else:
				idle_timer.start()
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

func _on_magnetic_zone_attract():
	match current_state:
		EnemyStates.IDLE:
			if can_see_player():
				change_state(EnemyStates.CHASE)
		EnemyStates.PATROL:
			if can_see_player():
				change_state(EnemyStates.CHASE)
		EnemyStates.CHASE:
			pass
		EnemyStates.LATCHED:
			pass

func _on_magnetic_zone_detach():
	match current_state:
		EnemyStates.IDLE:
			pass
		EnemyStates.PATROL:
			pass
		EnemyStates.CHASE:
			change_state(EnemyStates.IDLE)
		EnemyStates.LATCHED:
			change_state(EnemyStates.IDLE)

func can_see_player() -> bool:
	if player in vision.get_overlapping_bodies():
		# Ray cast check line of sight isnt obscured by environment
		var query = PhysicsRayQueryParameters2D.create(global_position, player.global_position, 1)
		var result = get_world_2d().direct_space_state.intersect_ray(query)
		return result.is_empty()
	return false

