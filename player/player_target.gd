extends Node2D
@onready var anim_player = $AnimationPlayer
@onready var spr2d = $OffsetNode
@export var radius := 150.0

var target:CharacterBody2D

func _ready() -> void:
	anim_player.play("start")
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * radius
	var starting_position = spr2d.position + offset
	var final_position = spr2d.position
	var duration: float = .15 # in seconds
	var tween := create_tween()
	tween.tween_property(spr2d, "position", final_position, duration).from(starting_position)
	
func play_loop_anim():
	anim_player.play("loop")
	anim_player.autoplay

func set_target(target_enemy):
	target=target_enemy

func _physics_process(delta: float) -> void:
	print(spr2d.position, spr2d.global_position)
	if is_instance_valid(target):
		global_position = target.global_position
	else:
		queue_free()
		

	
