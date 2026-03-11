extends PlayerState
var stun_duration := 10
var stun_timer := 0
func enter(previous_state_path: String, data: Dictionary = {}) -> void:
	stun_duration = data["stun_duration"]
	stun_timer=stun_duration
	
func physics_update(delta: float) -> void:
	if stun_timer > 0:
		stun_timer-=1*delta
	else:
		finished.emit("Idle")
	
