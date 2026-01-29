extends Enemy
@onready var animation_player = $AnimationPlayer
@onready var ball = $ZenithBall
var AGGRO_object:Player
const SPEED = 30
var ball_enabled = false
func _ready() -> void:
	current_state=States.IDLE
	health=MAX_HEALTH
	

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
			if global_position.distance_to(AGGRO_object.global_position) > 350:
				current_state = States.IDLE
			
			if global_position.distance_to(AGGRO_object.global_position) < 200:
				current_state = States.PREP_ATTACK
		States.PREP_ATTACK:
			look_at(AGGRO_object.global_position)
			print("HEYYY")
			if !animation_player.is_playing():
				animation_player.play("prep_attack")
			if global_position.distance_to(AGGRO_object.global_position) > 250:
				current_state = States.AGGRO
			
func _on_area_2d_body_entered(body: Player) -> void:
	AGGRO_object = body
