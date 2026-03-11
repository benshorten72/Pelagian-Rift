extends CharacterBody2D
class_name Enemy
enum states {}
var current_state: States
enum States {
	IDLE,
	AGGRO,
	ATTACKING,
	PREP_ATTACK,
	STUNNED,
	RECHARGING
}
var health:float
@export var MAX_HEALTH = 180
const FRICTION = 400.0

func move_towards_point(target: Vector2, speed: float,lerp_factor := 0.15) -> void:
	var dir = (target - global_position).normalized()
	velocity = velocity.lerp(dir * speed,lerp_factor)
	move_and_slide()

func apply_friction(delta: float) -> void:
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

func push(push_from_point, strength):
	var direction = (push_from_point - global_position).normalized()
	velocity = -(direction * strength)
	move_and_slide()

func move_and_firction(delta:float) ->void:
	apply_friction(delta)
	move_and_slide()

func get_executable_object()->ExecutableObject:
	return $ExecutableObject
