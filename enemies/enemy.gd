extends Enemy

@onready var detection_area:Area2D = $Area2D
var bulletScene = preload("res://enemies/bullet.tscn")
@onready var target_scene = preload("res://player/backgroundObjects/playerTarget.tscn")

@onready var timer:Timer = $Timer
@onready var executable_object:ExecutableObject = $ExecutableObject

const SPEED = 30
const ATTACK_SPEED = 50
const THRESHOLD_PERCENTAGE = .25
var attack_speed_cdn = ATTACK_SPEED

var AGGRO_object:CharacterBody2D = null
var has_created_target = false

var execute_function=func ():	
	take_damage(20000)
	
	
func _ready() -> void:
	current_state=States.IDLE
	health = MAX_HEALTH
	print("Hi", global_position)
	executable_object.set_execute_function(execute_function)


func is_executable():
	if health / float(MAX_HEALTH) > THRESHOLD_PERCENTAGE:
		return false
	else:
		executable_object.set_is_executable(true)
		executable_object.set_origin(global_position)
		return true
func take_damage(amount):
	health -= amount
	current_state=States.STUNNED
	if health <= 0:
		queue_free()
	timer.start()
	
	
func fire():
	var bullet = bulletScene.instantiate()
	bullet.global_position = global_position
	get_tree().current_scene.add_child(bullet)
	bullet.init(AGGRO_object.global_position)

func return_IDLE():
	current_state = States.AGGRO
	attack_speed_cdn = ATTACK_SPEED
	

func _physics_process(delta: float) -> void:
	
	if is_instance_valid(executable_object):
		executable_object.set_origin(global_position)
	is_executable()
	match current_state:
		States.IDLE:
			if AGGRO_object != null:
				current_state = States.AGGRO
		States.AGGRO:
			if AGGRO_object == null or !is_instance_valid(AGGRO_object):
				current_state = States.IDLE
				return_IDLE()
				return
			if global_position.distance_to(AGGRO_object.global_position) > 285:
				current_state = States.IDLE
				return_IDLE()
				return
				
			attack_speed_cdn-=1
			if attack_speed_cdn < 1:
				attack_speed_cdn=ATTACK_SPEED
				current_state = States.ATTACKING
			
			super.move_towards_point(AGGRO_object.global_position, SPEED)

		States.ATTACKING:
			current_state = States.AGGRO
			fire()
		States.STUNNED:
			move_and_slide()

		
		
func _on_area_2d_body_entered(body: Player) -> void:
		AGGRO_object = body


func _on_timer_timeout() -> void:
	current_state= States.IDLE
