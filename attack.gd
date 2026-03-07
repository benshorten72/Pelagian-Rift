extends PlayerState

@export var next_state:String
@export var animation:String
@export var damage := 32
@export var knockback := 100
var hit_targets := []

@onready var anim_sprite = $"../../AnimatedSprite2D"
@onready var slash_scene = preload("res://player/slashEffect.tscn")

#func _on_hurt_box_body_entered(body) -> void:
	#if body is Enemy:
			#print(damage)
			#var slash = slash_scene.instantiate()
			#player.get_parent().add_child(slash)
			#slash.global_position = body.global_position
			#body.take_damage(damage)
			#body.push(player.global_position, knockback)
#when i enter the state i need to check for enemies currently in area,
# because they dont 'enter' the area if they  are already in it when next attack state is loaded
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if (area.is_in_group("projectiles")):
		area.get_parent().queue_free()


func enter(previous_state_path: String, data := {}) -> void:
	player.action_pressed = false
	player.dodge_pressed = false
	player.can_input=false
	player.can_dodge_cancel = false
	player.animation_player.play(animation)
	player.hurtbox.area_entered.connect(_on_hurt_box_area_entered)
	hit_targets.clear()
	apply_damage()
	
func get_state_name():
	return "HEY"
	
func apply_damage():
	for area in player.hurtbox.get_overlapping_areas():
		if area is HyperionLightShield:
			if area.check_is_facing(player.global_position):
				player.push(area.global_position,150)
				finished.emit("Stunned", {
					"stun_duration": 5
				})
				return
	for body in player.hurtbox.get_overlapping_bodies():
		if body is Enemy and body not in hit_targets:
			body.take_damage(damage)
			hit_targets.append(body)
			var slash = slash_scene.instantiate()
			player.get_parent().add_child(slash)
			slash.global_position = body.global_position
			body.take_damage(damage)
			body.push(player.global_position, knockback)

				
			
func physics_update(delta: float) -> void:
	player.velocity = lerp(player.velocity, player.get_input() * player.SPEED/3, delta * player.ACCEL)
	apply_damage()
			
	if (player.dodge_pressed) and (player.can_dodge_cancel):
		finished.emit(DODGE)
	if not player.animation_player.is_playing():
		finished.emit(IDLE)
	if Input.is_action_just_pressed("attack"):
		player.action_pressed = true
	if Input.is_action_just_pressed("dodge"):
		player.dodge_pressed = true
	if next_state and player.can_input and player.action_pressed:
		if next_state == "attack2":
			finished.emit(ATTACK2)
		if next_state == "attack3":
			finished.emit(ATTACK3)
	player.move_and_slide()

func exit() -> void:
	if player.hurtbox.area_entered.is_connected(_on_hurt_box_area_entered):
		player.hurtbox.area_entered.disconnect(_on_hurt_box_area_entered)
