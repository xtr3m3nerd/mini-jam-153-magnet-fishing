extends Node

@export var starting_money: int = 1000
@export var starting_weight: float = 0.0
@export var starting_upgrades: Array[Upgrade] = []

var pickups : Array[Pickup] = []
var upgrades : Array[Upgrade] = []
var picked_up_ids : Array[int] = []
var money : int = 50
var weight : float = 0.0

func _ready():
	reset()

func reset():
	money = starting_money
	weight = starting_weight
	upgrades = starting_upgrades.duplicate()
	pickups = []
	picked_up_ids = []
