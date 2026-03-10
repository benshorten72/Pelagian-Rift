extends Node2D
@onready var ripple := $SubViewport/WaterRipple
var parent:Node2D

func _ready() -> void:
	parent=get_parent()

func _process(delta: float) -> void:
	var speed = parent.velocity.length()

	var scale01 = clamp(inverse_lerp(parent.SPEED,0,  speed), 0, .2)
	ripple.scale = Vector2.ONE * scale01
