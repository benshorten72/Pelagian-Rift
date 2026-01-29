class_name Player
extends CharacterBody2D

@export var _animation_player:NodePath
@onready var animation_player:AnimationPlayer = get_node(_animation_player)
@onready var hurtbox = $HurtBox
@onready var state_machine = $StateMachine

const SPEED = 300.0 
const BONUS_SPEED=200.0
const ACCEL = 4.0 
const DASH_OFFSET = 20
const DASH_TIME_TO_REACH = .1
var input: Vector2


var can_input = true
var can_dodge_cancel = true
var action_pressed = false
var dodge_pressed = false
var closest = null
var dash_elapsed_time = 0.0
var dash_start_position: Vector2
var dash_target_position: Vector2

# On creation, player object creates a mouse object that handles detecting
# Enemies in an area and whether they are valid for a dash execute. Player should
# not have to deal with figuring out whether enemie is valid or not
@onready var mouse_scene = preload("res://player/MouseObject.tscn")
@onready var slash_scene = preload("res://player/slashEffect.tscn")

var mouse_instance

func _ready() -> void:
	mouse_instance = mouse_scene.instantiate()
	add_child(mouse_instance)
	print(mouse_instance)

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y =  Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()


func _process(delta: float):
	get_input()

func ready_for_input():
	can_input = true
	
func ready_for_dodge_cancel():
	can_dodge_cancel = true
func _on_hurt_box_body_entered(body) -> void:
	if body is Enemy:
		print(body)
		var current_state = str(state_machine.state.get_name()).to_lower()
		var slash = slash_scene.instantiate()
		get_parent().add_child(slash)
		slash.global_position = body.global_position
		match (current_state):
			"attack1":
				print(body)
				body.take_damage(25)
				body.push(global_position, 100)
			"attack2":
				body.take_damage(50)
				body.push(global_position, 200)

			"attack3":
				body.take_damage(75)
				body.push(global_position, 300)
				



func _on_hurt_box_area_entered(area: Area2D) -> void:
	if (area.is_in_group("projectiles")):
		area.get_parent().queue_free()
