extends Area2D

func _ready() -> void:
		rotate(randf_range(1.2,5.0))


func _on_body_entered(body: Node2D) -> void:
	if (body.is_in_group("enemies")):
		body.take_damage(10)
		body.push(global_position,300)

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_animated_sprite_2d_animation_looped() -> void:
	queue_free()
