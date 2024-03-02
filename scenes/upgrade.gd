extends Resource
class_name Upgrade

@export var price: int = 10
@export var name = "Placeholder Name"

enum Types {LENGTH, SWING_SPEED, DEPTH_SPEED, STRENGTH, FLASHLIGHT, HEAT_RESISTANCE}
@export var type : Types = Types.LENGTH

@export var texture : CompressedTexture2D
