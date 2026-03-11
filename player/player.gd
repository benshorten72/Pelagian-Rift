class_name Player
extends CharacterBody2D

@export var _animation_player:NodePath
@onready var animation_player:AnimationPlayer = get_node(_animation_player)
@onready var hurtbox := $HurtBox
@onready var state_machine = $StateMachine

const MAX_HEALTH = 100
const SPEED = 300.0 
const BONUS_SPEED=200.0
const ACCEL = 4.0 
const DASH_OFFSET = 20
const DASH_TIME_TO_REACH = .1
var input: Vector2

var health:int
var can_input = true
var can_dodge_cancel = true
var action_pressed = false
var dodge_pressed = false
var closest:ExecutableObject = null
var dash_elapsed_time = 0.0
var dash_start_position: Vector2
var dash_target_position: Vector2

# On creation, player object creates a mouse object that handles detecting
# Enemies in an area and whether they are valid for a dash execute. Player should
# not have to deal with figuring out whether enemie is valid or not
@onready var mouse_scene = preload("res://player/backgroundObjects/MouseObject.tscn")

var mouse_instance:MouseObject

func _ready() -> void:
	mouse_instance = mouse_scene.instantiate()
	add_child(mouse_instance)
	health=MAX_HEALTH
	

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
func push(push_from_point, strength):
	var direction = (push_from_point - global_position).normalized()
	velocity = -(direction * strength)
	move_and_slide()

func hurt(amount:int, push_from_point=global_position, strength=1):
	health-=amount
	push(push_from_point, strength)
	
