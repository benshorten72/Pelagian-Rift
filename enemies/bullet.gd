extends Node2D
const SPEED = 3
const PUSH_AMOUNT=5
var target:Vector2
var dir:Vector2 = Vector2.ZERO
const DAMAGE = 5
func init(_target:Vector2):
	target=_target
	dir = (target - global_position).normalized()
	rotation = dir.angle()*30
	
func _physics_process(delta: float) -> void:
	position += dir * SPEED


func _on_area_2d_body_entered(body: Player) -> void:
	if (body.hurt(DAMAGE,self.global_position,PUSH_AMOUNT)):
		queue_free()
