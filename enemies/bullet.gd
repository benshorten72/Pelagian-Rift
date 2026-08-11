extends Node2D
class_name Bullet
const PUSH_AMOUNT=5
var target:Vector2
var dir:Vector2 = Vector2.ZERO
const DAMAGE = 5
var speed
@onready var area2d = $Area2D
@onready var collision_shape = $Area2D/CollisionShape2D

func init(_target:Vector2, dir_to=null, input_speed=null):
	set_process(true)
	target=_target
	if dir_to == null:
		dir = (target - global_position).normalized()
	else:
		dir = dir_to.normalized()
	if input_speed == null:
		speed = 10
	else:
		speed = input_speed
	rotation = dir.angle()*30
	
func _physics_process(delta: float) -> void:
	position += dir * speed * delta


func disable():
	visible = false
	if collision_shape:
		collision_shape.set_deferred("disabled", true)
	set_physics_process(false)

func enable():
	visible = true
	if collision_shape:
		collision_shape.set_deferred("disabled", false)
	set_physics_process(true)
	
func despawn():
	disable()
	ProjectileStoreGlobal.add_to_bullet_array(self)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.hurt(DAMAGE, global_position, PUSH_AMOUNT):
			despawn()
	elif body is TileMapLayer:
		despawn()
