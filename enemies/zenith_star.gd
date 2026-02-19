extends Enemy
class_name ZenithStar
@onready var animation_player = $AnimationPlayer
@onready var ball_scene = preload("res://enemies/zenith_ball.tscn")

var AGGRO_object:Player
const SPEED = 30
var ball_enabled = false
var ball:ZenithBall = null
func _ready() -> void:
	current_state=States.IDLE
	health=MAX_HEALTH
const attack_range =200

func _physics_process(delta: float) -> void:
	#if is_executable():
		#health_bar.modulate = Color(1,.5,.5,1)
	match current_state:
		States.IDLE:
			if AGGRO_object != null:
				current_state = States.AGGRO
		States.AGGRO:
			if AGGRO_object == null:
				current_state = States.IDLE
			move_towards_point(AGGRO_object.global_position,SPEED)
			if global_position.distance_to(AGGRO_object.global_position) > attack_range+150:
				current_state = States.IDLE
			
			if global_position.distance_to(AGGRO_object.global_position) < attack_range:
				current_state = States.PREP_ATTACK
		States.PREP_ATTACK:
			look_at(AGGRO_object.global_position)
			rotate(deg_to_rad(270))
			if !animation_player.is_playing():
				animation_player.play("prep_attack")
			if global_position.distance_to(AGGRO_object.global_position) > 250:
				current_state = States.AGGRO
		States.RECHARGING:
			animation_player.play("pulling")
		States.STUNNED:
			animation_player.play("recoil")

					
					
			
func _on_area_2d_body_entered(body: Player) -> void:
	AGGRO_object = body

func create_ball()->void:
	var ball_instance:ZenithBall = ball_scene.instantiate()
	get_parent().add_child(ball_instance)
	ball_instance.zenith_parent=self
	ball_instance.global_position=global_position
	ball = ball_instance
	current_state = States.RECHARGING
	
func recover_pull()->void:
	ball.queue_free()
	current_state=States.AGGRO

func recoil_over()->void:
	current_state=States.AGGRO
	
