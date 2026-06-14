extends PlayerState
var dodge_strength = 1100
var dodge_duration = 0.09
var dodge_time = 0.0

func enter(previous_state_path: String, data := {}) -> void:
	var direction = (player.get_global_mouse_position() - player.global_position).normalized()
	player.velocity = direction * dodge_strength
	dodge_time = 0.0
	player.can_be_hurt = false
	player.modulate.r =0
	
func physics_update(delta: float) -> void:
	
	dodge_time += delta
	player.move_and_slide()
	
	if dodge_time >= dodge_duration:
		player.modulate.r =1
		player.can_be_hurt=true
		player.velocity = player.velocity/2
		player.start_dodge_timer()
		finished.emit(IDLE)
