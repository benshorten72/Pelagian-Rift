extends PlayerState

@export var _animation_player:NodePath
@onready var head = $"../../head"
@onready var torso = $"../../AnimatedSprite2D"
@onready var speed_boost_timer:Timer = $"../../SpeedBoostTimer"
@onready var animation_player:AnimationPlayer = get_node(_animation_player)
@onready var dash_effect_scene = preload("res://player/dashing/dashoffEffect.tscn")

const ROTATE_THRESHOLD := PI / 2  
var speed_timer_wait
var curr_rotation
var current_anim := ""
var bonus_speed= 0
var dash_effect_rotation_offset = 270

func enter(previous_state_path: String, data := {}) -> void:
	animation_player.active=true
	curr_rotation = player.rotation+90
	bonus_speed=0
	speed_timer_wait = speed_boost_timer.wait_time
	animation_player.play("idle")
	player.hurtbox.collision_shape.disabled=true
func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("dash"):
		finished.emit(DASH)
	if Input.is_action_just_pressed("attack"):
		finished.emit(ATTACK1)
	if Input.is_action_just_pressed("dodge"):
		if player.can_dodge:
			finished.emit(DODGE)
	player.velocity = lerp(player.velocity, player.get_input() * (player.SPEED+bonus_speed), delta * player.ACCEL)	
	
	player.look_at(player.get_global_mouse_position())
	player.move_and_slide()
	if (player.velocity.abs().x+player.velocity.abs().y) > 150:
		
		if speed_boost_timer.paused==true and bonus_speed == 0:
			speed_boost_timer.start()
			speed_boost_timer.paused=false
		
		var input_dir := Vector2(player.input.x,player.input.y).normalized()
		var local_dir = input_dir.rotated(-player.rotation)
		dash_effect_rotation_offset=270

		if abs(local_dir.x) > abs(local_dir.y):
			if local_dir.x > 0:
				play_anim("run")
			else:
				play_anim("reverse-run")
				dash_effect_rotation_offset=90
		else:
			if local_dir.y < 0:
				torso.flip_h =1
				dash_effect_rotation_offset=180

			else: 
				torso.flip_h =0
				dash_effect_rotation_offset=0

			play_anim("strafe-run")
	else:
			dash_effect_rotation_offset=270
			play_anim("idle")
			speed_boost_timer.paused = true
			bonus_speed=0
			speed_boost_timer.wait_time = speed_timer_wait


func play_anim(name: String):
	if current_anim == name:
		return
	current_anim = name
	animation_player.play(name)


func _on_speed_boost_timer_timeout() -> void:
	bonus_speed=player.BONUS_SPEED
	var dash_effect:AnimatedSprite2D = dash_effect_scene.instantiate()
	get_parent().add_child(dash_effect)
	dash_effect.global_position = player.global_position
	dash_effect.rotation = (player.rotation+deg_to_rad(dash_effect_rotation_offset))
	speed_boost_timer.paused=true
	speed_boost_timer.wait_time = speed_timer_wait
