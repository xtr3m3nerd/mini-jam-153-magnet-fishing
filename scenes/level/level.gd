extends Node2D

@onready var pickups = $Pickups

# Called when the node enters the scene tree for the first time.
func _ready():
	free_picked_ups()
	pass # Replace with function body.


func free_picked_ups():
	for pickup in PlayerManager.picked_up_ids:
		pickups.get_child(pickup).queue_free()
