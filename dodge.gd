extends PlayerState
var dodge_strength = 600
var dodge_duration = 0.04
var dodge_time = 0.0

func enter(previous_state_path: String, data := {}) -> void:
	print("Dodge entered")
	var direction = (player.get_global_mouse_position() - player.global_position).normalized()
	player.velocity = direction * dodge_strength
	dodge_time = 0.0
func physics_update(delta: float) -> void:
	dodge_time += delta
	player.move_and_slide()

	if dodge_time >= dodge_duration:
		finished.emit(IDLE)
