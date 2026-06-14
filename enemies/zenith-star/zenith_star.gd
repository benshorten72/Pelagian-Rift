extends Enemy
class_name ZenithStar
@onready var animation_player = $AnimationPlayer
@onready var ball_scene = preload("res://enemies/zenith-star/zenithBall.tscn")
@onready var shield := $HyperionLightShield
@onready var executable_object:ExecutableObject = $ExecutableObject
@onready var hitbox = $hitbox
@onready var rope:Rope = $Rope
@onready var timer:Timer = $Timer
var AGGRO_object:Player
const SPEED = 130
var ball_enabled = false
var ball:ZenithBall = null
const THRESHOLD_PERCENTAGE = .40

var execute_function=func ():	
	take_damage(20000)
	
func _ready() -> void:
	enter_idle()
	health=MAX_HEALTH
	executable_object.set_execute_function(execute_function)
	rope.disable()
	
const attack_range =200

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
		
func is_executable():
	if health / float(MAX_HEALTH) > THRESHOLD_PERCENTAGE:
		return false
	else:
		executable_object.set_is_executable(true)
		executable_object.set_origin(hitbox.global_position)
		return true
		
func _physics_process(delta: float) -> void:
	#if is_executable():
		#health_bar.modulate = Color(1,.5,.5,1)
	is_executable()
	match current_state:
		States.IDLE:
			shield.set_enabled(true)
			if AGGRO_object != null:
				enter_agro()

		States.AGGRO:
			shield.set_enabled(true)
			look_at(AGGRO_object.global_position)
			rotate(deg_to_rad(270))
			if AGGRO_object == null:
				enter_agro()
			move_towards_point(AGGRO_object.global_position,SPEED)
			
			if global_position.distance_to(AGGRO_object.global_position) > attack_range+150:
				enter_agro()
			
			if global_position.distance_to(AGGRO_object.global_position) < attack_range:
				enter_prep_attack()
		States.PREP_ATTACK:
			shield.set_enabled(true)

			look_at(AGGRO_object.global_position)
			rotate(deg_to_rad(270))
			if !animation_player.is_playing():
				animation_player.play("prep_attack")
			if global_position.distance_to(AGGRO_object.global_position) > 250:
				enter_agro()
		States.RECHARGING:
			animation_player.play("pulling")
		States.STUNNED:
			animation_player.play("recoil")
			shield.set_enabled(false)
	move_and_friction(delta)
					
					
			
func _on_area_2d_body_entered(body: Player) -> void:
	AGGRO_object = body

func create_ball()->void:
	var ball_instance:ZenithBall = ball_scene.instantiate()
	get_parent().add_child(ball_instance)
	ball_instance.zenith_parent=self
	ball_instance.global_position=global_position
	ball = ball_instance
	current_state = States.RECHARGING
	rope.create(ball)
	rope.set_process(true)
	
func recover_pull()->void:
	if is_instance_valid(ball):
		ball.queue_free()
		current_state=States.AGGRO

func enter_agro():
	current_state=States.AGGRO
	animation_player.play("run")

func enter_idle():
	current_state=States.IDLE
	run_animation()
func enter_prep_attack():
	current_state=States.PREP_ATTACK
	
	animation_player.play("prep_attack")
func run_animation() -> void:
	var prob = randi_range(1,10)
	if prob > 5:
		animation_player.play("idle")
	else:
		animation_player.play("idle-alt")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if current_state==States.IDLE:
		run_animation()

func timer_start():
	print("Timer started")
	rope.activate_whacking()
	timer.start(.2)
	
func _on_timer_timeout() -> void:
	rope.disable()
	print("Timer ended, rope disabeld")
	#current_state=States.STUNNED

func whack():
	# set rope to begin disabled
	if current_state == States.RECHARGING:
		current_state = States.STUNNED
		rope.disable()
