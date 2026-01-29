extends CharacterBody2D
const SPEED = 200
var target:Vector2
var dir:Vector2 = Vector2.ZERO

func init(_target:Vector2):
	target=_target
	dir = (target - global_position).normalized()
	rotation = dir.angle()*30
	
func _physics_process(delta: float) -> void:
	velocity = dir * SPEED
	move_and_slide()
	
