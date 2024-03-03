extends Resource
class_name Upgrade

@export var price: int = 10
@export var name = "Placeholder Name"
@export var level = 1

enum Types {LENGTH, SWING_SPEED, DEPTH_SPEED, STRENGTH, FLASHLIGHT}
@export var type : Types = Types.LENGTH
@export var value: float = 0.0

@export var texture : CompressedTexture2D
