extends PlayerState

@export var next_state:String
@export var animation:String
@onready var anim_sprite = $"../../AnimatedSprite2D"
func enter(previous_state_path: String, data := {}) -> void:
	player.action_pressed = false
	player.dodge_pressed = false
	player.can_input=false
	player.can_dodge_cancel = false
	player.animation_player.play(animation)

func get_state_name():
	return "HEY"

func physics_update(delta: float) -> void:
	player.velocity = lerp(player.velocity, player.get_input() * player.SPEED/3, delta * player.ACCEL)
	if (player.dodge_pressed) and (player.can_dodge_cancel):
		finished.emit(DODGE)
	if not player.animation_player.is_playing():
		finished.emit(IDLE)
	if Input.is_action_just_pressed("attack"):
		player.action_pressed = true
	if Input.is_action_just_pressed("dodge"):
		player.dodge_pressed = true
	if next_state and player.can_input and player.action_pressed:
		print("next combo:",next_state.to_upper())
		if next_state == "attack2":
			finished.emit(ATTACK2)
		if next_state == "attack3":
			finished.emit(ATTACK3)
	player.move_and_slide()
