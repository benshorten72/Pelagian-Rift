extends AnimatedSprite2D
#
#
func _on_animation_looped() -> void:
	queue_free()
