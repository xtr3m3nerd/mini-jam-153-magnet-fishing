extends CanvasLayer

@onready var fade_rect : ColorRect = $ColorRect
@onready var player: Node2D = get_tree().get_first_node_in_group("player")
@onready var collection_zone_point_y : float = $"../../CollectionZone".global_position.y - 75

@onready var fade_start_point_y : float = $"../../CollectionFadeStartPoint".global_position.y

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if(fade_start_point_y > player.global_position.y):
		var alpha = (player.global_position.y - fade_start_point_y) / (collection_zone_point_y - player.global_position.y)
		
		fade_rect.color = Color(0,0,0, alpha)
		
		pass
	
	
	
	pass
