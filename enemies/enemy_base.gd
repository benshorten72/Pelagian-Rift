extends Node2D
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
var velocity: Vector2 = Vector2.ZERO

func move_towards_point(target: Vector2, speed: float, lerp_factor := 0.15) -> void:
	var dir = (target - global_position).normalized()
	velocity = velocity.lerp(dir * speed, lerp_factor)

func pathfind_to_target(nav_agent:NavigationAgent2D, speed:float, lerp_factor :=0.15):
	var nav_pos = nav_agent.get_next_path_position()
	var dir = (nav_pos-global_position).normalized()
	velocity = velocity.lerp(dir*speed, lerp_factor)
	
func apply_friction(delta: float) -> void:
	if velocity.length() > 0:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
func push(push_from_point: Vector2, strength: float):
	var direction = (push_from_point - global_position).normalized()
	velocity = -(direction * strength)

func move_and_friction(delta: float) -> void:
	apply_friction(delta)
	global_position += velocity * delta

func get_executable_object()->ExecutableObject:
	return $ExecutableObject
