extends Camera2D
@export var followingObject:CameraFollowable

func _process(delta: float) -> void:
	if !is_instance_valid(followingObject):
		push_warning("Camera: No followable object found for camera, deleting")
		queue_free()
	else:
		global_position=followingObject.global_position
	
