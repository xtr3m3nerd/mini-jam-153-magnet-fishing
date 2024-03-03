class_name PendulumBody2D
extends CharacterBody2D
 
@onready var magnetic_zone : Area2D = $MagneticZone
@onready var magnet_vfx = $MagnetVFX

signal attract()
signal detach()


@export var anchor: Vector2 = Vector2.ZERO
@export var length_speed: float = 50.0
@export var swing_speed: float = 100.0
@export var damping: float = 0.9
@export var mass: float = 1.0
@export var max_length: float = 2000.0

var length := 1.0
var angle := 0.0
var angular_velocity := 0.0
var angular_accelleration := 0.0
var angular_momentum := 0.0
var used_length := 0.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var sound_player := AudioStreamPlayer.new()

func _ready():
	length = anchor.distance_to(global_position)
	angular_momentum = mass * angular_velocity * length
	
	var base_stength = magnetic_zone.magnetic_strength
	for upgrade in PlayerManager.upgrades:
		match upgrade.type:
			Upgrade.Types.LENGTH:
				if upgrade.value > max_length:
					max_length = upgrade.value
			Upgrade.Types.SWING_SPEED:
				if upgrade.value > swing_speed:
					swing_speed = upgrade.value
			Upgrade.Types.DEPTH_SPEED:
				if upgrade.value > length_speed:
					length_speed = upgrade.value
			Upgrade.Types.STRENGTH:
				if upgrade.value > magnetic_zone.magnetic_strength:
					magnetic_zone.magnetic_strength = upgrade.value
					magnet_vfx.speed_scale = magnetic_zone.magnetic_strength / base_stength
			Upgrade.Types.FLASHLIGHT:
				pass
	
	add_child(sound_player)

func _process(delta):
	var change = Input.get_axis("move_up", "move_down")
	length += change * length_speed * delta
	if used_length + length > max_length:
		length = max_length - used_length
		# TODO - indicate chain is maxed out
	angular_velocity = angular_momentum / (mass * length)

func _physics_process(delta):
	angle = -PI/2 + atan2(global_position.y - anchor.y, global_position.x - anchor.x)
	angular_accelleration = gravity * sin(angle)
	angular_velocity += angular_accelleration * delta
	angular_velocity *= pow(damping, delta)
	
	var direction = Input.get_axis("move_left", "move_right")
	angular_velocity += direction * swing_speed * delta
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
	
	if length < 16 and global_position.y > anchor.y - 8.0:
		velocity += Vector2.UP * 500.0
	
	var collision := move_and_collide(velocity * delta,true)
	
	if collision:
		angular_velocity = 0.0
		angular_momentum = 0.0
	
	move_and_slide()
	
	var corrected_length = global_position.distance_to(anchor)
	length = corrected_length
	rotation = angle

func update_anchor(new_anchor: Vector2, new_used_length: float):
	anchor = new_anchor
	length = global_position.distance_to(new_anchor)
	used_length = new_used_length

func set_starting(new_anchor: Vector2, pos: Vector2):
	anchor = new_anchor
	global_position = pos
	length = anchor.distance_to(global_position)
	angular_velocity = 0.0
	angular_momentum = 0.0


func _on_magnetic_zone_attract():
	attract.emit()
	var sound_effect = load("res://assets/sfx/attract.wav")
	sound_player.stream = sound_effect
	sound_player.play()
	magnet_vfx.emitting = true

func _on_magnetic_zone_detach():
	detach.emit()
	var sound_effect = load("res://assets/sfx/magnetoff.wav")
	sound_player.stream = sound_effect
	sound_player.play()
	magnet_vfx.emitting = false
