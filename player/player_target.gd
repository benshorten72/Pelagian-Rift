extends Node2D
class_name Target
@onready var anim_player = $AnimationPlayer
@onready var spr2d = $OffsetNode
@export var radius := 150.0
var offset = Vector2.ZERO
var target

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

func set_target_origin(origin):
	global_position=origin
		

	
