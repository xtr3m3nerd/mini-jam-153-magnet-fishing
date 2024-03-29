extends Area2D

signal attract()
signal detach()

@export var magnetic_strength = 2000
@export var magnetic_stength_curve: Curve
@export var magnetic_curve_range: float = 200.0
@onready var general_pull = $GeneralPull
@onready var directional_pull = $DirectionalPull

var is_magnet_active := false:
	set(value):
		if is_magnet_active != value:
			is_magnet_active = value
			if value:
				attract.emit()
			else:
				detach.emit()
			if general_pull:
				general_pull.visible = value
			if directional_pull:
				directional_pull.visible = value

var sticky_pickups = []
var springs = []

func _ready():
	if not magnetic_stength_curve:
		magnetic_stength_curve = Curve.new()

	general_pull.visible = is_magnet_active
	directional_pull.visible = is_magnet_active

func _process(_delta):
	is_magnet_active = Input.is_action_pressed("magnet")

func _physics_process(delta):
	if is_magnet_active:
		for pickup in get_overlapping_bodies():
			var pickup_distance = pickup.global_position.distance_to(global_position)
			var pull_dir = pickup.global_position.direction_to(global_position).normalized()
			
			var curve_strength = magnetic_stength_curve.sample(clamp(1.0 - pickup_distance/magnetic_curve_range, 0.0, 1.0))
			var force = pull_dir * magnetic_strength * curve_strength
			pickup.apply_central_impulse(force * delta)
