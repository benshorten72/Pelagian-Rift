extends Node2D
class_name ExecutableObject
var has_created_target:bool = false
@onready var target_scene = preload("res://player/playerTarget.tscn")
var parent:Node2D
var origin:Vector2 
var target:Target
var is_executable:bool = false
var execute_function = func (): print("ah Im executed")
@onready var executable_detect:Area2D = $"ExecutableDetectBox"
#Interfaces for player.dash & mouseObject. Parent changes logic by setting calls and lambdas
func _ready() -> void:
#	init vars
	parent = get_parent()
	parent.add_to_group("executables")
	
func _physics_process(delta: float) -> void:
	if is_instance_valid(executable_detect):
		executable_detect.global_position=origin
	if is_executable:
		create_target()
	if has_created_target and is_instance_valid(target):
		target.set_target_origin(origin)

func create_target():
	if !has_created_target:
			target = target_scene.instantiate()
			add_child(target)
			target.set_target_origin(origin)
			has_created_target=true
			

func set_origin(new_origin:Vector2):
	origin=new_origin
func set_is_executable(executable:bool):
	is_executable=executable

func set_execute_function(new_execute_function):
	execute_function = new_execute_function

func execute():
	execute_function.call()
	if is_instance_valid(target):
		queue_free()
