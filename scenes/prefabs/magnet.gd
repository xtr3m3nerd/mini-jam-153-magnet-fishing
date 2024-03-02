extends RigidBody2D

@export var FORCE = 400
@export var magnetic_strength = 100000
@onready var magnetic_zone: Area2D = $MagneticZone
@onready var sticky_zone: Area2D = $StickyZone
var is_magnet_active = false

var sticky_objects = []
var sticky_colliders = []
var original_sticky_colliders = []

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

func _on_body_entered(body):
	if is_magnet_active and body.is_in_group("object") and not body in get_children():
		var sticky = body.get_node("StickyZone")
				
		var sticky_addition = sticky.duplicate()
		sticky.get_node("CollisionShape2D").disabled = true
				
		sticky_zone.add_child(sticky_addition)
		sticky_addition.global_position = body.position
				
		var body_pos = body.position
		body.get_parent().remove_child(body)
		self.add_child(body)
		body.global_position = body_pos
		body.get_node("CollisionShape2D").disabled = false
		body.sleeping = true
		body.gravity_scale = 0
		body.is_stickied = true

		original_sticky_colliders.append(sticky)
		sticky_colliders.append(sticky_addition)
		sticky_objects.append(body)
	
	pass # Replace with function body.


func _on_body_exited(body):
	
	#if body.is_in_group("object"):
		#var sticky = body.get_node("StickyZone")
		#sticky.get_node("CollisionShape2D").disabled = false
		#original_sticky_colliders.erase(sticky)
		#
		#var sticky_collider = body.get_node("CollisionShape2D")
		#sticky_zone.remove_child(sticky_collider)
		#sticky_colliders.erase(sticky_collider)
		##sticky_collider.queue_free()
#
		#
		#body.get_node("CollisionShape2D").disabled = false
		#body.sleeping = false
		#body.gravity_scale = 1
		#body.freeze = false
		#body.is_stickied = false
#
		#var body_pos = body.global_position
		#remove_child(body)
		#get_parent().get_parent().add_child(body)
		#body.global_position = body_pos


	pass # Replace with function body.


func unstick_objects():
	for sticky_collider in sticky_colliders:
		sticky_collider.queue_free()
		
	for sticky in original_sticky_colliders:
		sticky.get_node("CollisionShape2D").disabled = false
		
	for object in sticky_objects:
		object.get_node("CollisionShape2D").disabled = false
		object.sleeping = false
		object.gravity_scale = 1
		object.freeze = false
		object.is_stickied = false
		
		var object_pos = object.global_position
		remove_child(object)
		get_parent().get_parent().add_child(object)
		object.global_position = object_pos
	
	sticky_objects = []
	sticky_colliders = []
	original_sticky_colliders = []
