extends SubViewportContainer
@export var follow_object:Node2D

func _process(delta: float) -> void:
	if is_instance_valid(follow_object):
		global_position=Vector2(follow_object.global_position.x-size.x/2,follow_object.global_position.y-size.y/2)
	else:
		push_warning("Relfection has no object")
