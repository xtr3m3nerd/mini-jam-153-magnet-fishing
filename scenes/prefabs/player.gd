extends Node2D

class_name Player

var pickups : Array[Pickup] = []
@export var upgrades : Array[Upgrade] = []

var money : int = 1000
var weight : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

