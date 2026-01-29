extends Node2D

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	rotate(randf_range(.1,.9))

func _on_animated_sprite_2d_animation_looped() -> void:
		queue_free()
