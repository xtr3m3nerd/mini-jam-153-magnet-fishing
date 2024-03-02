extends CharacterBody2D

const SPEED = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = input_dir.normalized()
	
	if direction:
		velocity = direction * SPEED
		move_and_slide()
