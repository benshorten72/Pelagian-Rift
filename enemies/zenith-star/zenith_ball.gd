extends Node2D
class_name ZenithBall
@onready var chain:Sprite2D = $Chain
@export var zenith_parent:ZenithStar
var aggro_object:Player
var velocity := Vector2(0,0)
var speed =800
var called = false
var friction_level:int = .2
var air_time = 1
var desired_scale
var starting_scale = Vector2(1.4,1.4)
@onready var target_scene = preload("res://player/backgroundObjects/playerTarget.tscn")
@onready var executable_object:ExecutableObject = $ExecutableObject2

var is_damaging = true
var has_hit_player=false
var has_created_target = false
@export var airtime_curve: Curve
@export var max_air_time := 0.6



func _ready() -> void:
	chain.region_rect.size = Vector2(32,100)
	chain.centered = false
	chain.region_rect.position = Vector2(-32, -32)
	scale = starting_scale
	desired_scale = starting_scale
	
	var execute_function=func ():	
		zenith_parent.timer_start()
		self.queue_free()
		
	executable_object.set_execute_function(execute_function)
	
func _physics_process(delta: float) -> void:
	if !is_instance_valid(zenith_parent):
		queue_free()
		return
	if is_instance_valid(zenith_parent) and is_instance_valid(zenith_parent.AGGRO_object):
		aggro_object=zenith_parent.AGGRO_object
	if is_instance_valid(executable_object):
		var midpoint = (global_position+zenith_parent.global_position)/2
		executable_object.set_origin(midpoint)	

	if !called and zenith_parent and zenith_parent.AGGRO_object:
		launch()
		called=true
	look_at(zenith_parent.global_position)
	chain.region_rect.size = Vector2(32,global_position.distance_to(zenith_parent.global_position)+12)
	chain.position = Vector2(16,0)
	
	velocity = velocity.lerp(Vector2.ZERO, delta * friction_level)
	position += velocity * delta
	scale = scale.lerp(desired_scale, 10 * delta)
	rotation+=velocity.length_squared()/10
	if velocity.length() < 200:
		is_executable()
		is_damaging=false
		
func is_executable():
	if is_instance_valid(executable_object):
		executable_object.set_is_executable(true)

func launch():
	var distance_ratio: float = clamp(
		global_position.distance_to(aggro_object.global_position)
		/ zenith_parent.attack_range,
		0.0,
		1.0
	)

	var airtime_factor: float = airtime_curve.sample(distance_ratio)
	air_time = airtime_factor * max_air_time

	speed = speed * distance_ratio
	velocity = speed * global_position.direction_to(aggro_object.global_position)

	await get_tree().create_timer(air_time).timeout
	friction_level = 5
	desired_scale = Vector2(1, 1)


func _on_area_2d_body_entered(player: Player) -> void:
	if is_damaging and !has_hit_player:
		player.hurt(20,global_position,500)
		has_hit_player=true
