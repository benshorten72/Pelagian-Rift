extends PlayerState
var executables_list:Array[ExecutableObject]
var min_distance = 100000
var distance = min_distance;
@onready var slash_scene = preload("res://player/dashing/DashSlash.tscn")
@onready var dash_effect_scene = preload("res://player/dashing/dashoffEffect.tscn")

func enter(previous_state_path: String, data := {}) -> void:
	print("Dash Entered")
	executables_list = player.mouse_instance.get_valid_executables()
	print(executables_list)
	distance = min_distance

	
func physics_update(delta: float) -> void:	
	if executables_list == null or typeof(executables_list)==TYPE_NIL:
		print("error with enemy list for dashing", executables_list)
		finished.emit(IDLE)
	if player.closest == null:
		player.dash_elapsed_time = 0
		for i in executables_list:
			if is_instance_valid(i):
				var current_dist = i.origin.distance_to(player.mouse_instance.global_position)
				if current_dist < distance:
					distance = current_dist
					player.closest = i

		if player.closest == null:
			print("No executables_list near mouse position")
			finished.emit(IDLE)
			return
			
		else:
			var direction = player.global_position.direction_to(player.closest.global_position)
			player.dash_start_position = player.global_position
			player.dash_target_position = player.closest.origin + direction * player.DASH_OFFSET
			player.mouse_instance.enemy_executed()
			var dash_effect:AnimatedSprite2D = dash_effect_scene.instantiate()
			get_parent().get_parent().get_parent().add_child(dash_effect)
			dash_effect.global_position = player.global_position
			dash_effect.rotation = (player.rotation+deg_to_rad(270))
					
	player.dash_elapsed_time += delta
	var t = clamp(player.dash_elapsed_time / player.DASH_TIME_TO_REACH, 0.0, 1.0)
	var eased_t = 1.0 - pow(1.0 - t, 2)  # ease-out
	player.global_position = player.dash_start_position.lerp(player.dash_target_position, eased_t)
	if t >= 1.0:
		player.closest.execute()
		player.closest = null
		var slash = slash_scene.instantiate()
		get_parent().get_parent().add_child(slash)
		finished.emit(IDLE)
