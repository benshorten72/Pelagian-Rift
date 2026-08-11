extends Enemy

@onready var detection_area:Area2D = $Area2D
var bulletScene = preload("res://enemies/bullet.tscn")
@onready var target_scene = preload("res://player/backgroundObjects/playerTarget.tscn")
@onready var navigation_grouper_area:Area2D = $NavigationGrouperAreaCheck
@onready var timer:Timer = $Timer
@onready var executable_object:ExecutableObject = $ExecutableObject
@onready var nav_agent_recalculate_timer:Timer = $NavAgentRecalculate
@onready var projectile_launcher:ProjectileLauncher = $ProjectileLauncher

const SPEED = 100
const ATTACK_SPEED = 50
const THRESHOLD_PERCENTAGE = .25
const MAX_GROUP_SIZE=7
var attack_speed_cdn = ATTACK_SPEED


var AGGRO_object:CharacterBody2D = null
var has_created_target = false

var nav_group_children:Array[Enemy] = []
var nav_parent:Enemy = null

var execute_function=func ():	
	take_damage(20000)

	
func _ready() -> void:
	current_state=States.IDLE
	health = MAX_HEALTH
	print("Hi", global_position)
	nav_agent_recalculate_timer.start(randf_range(0.7,1))
	executable_object.set_execute_function(execute_function)
	if is_instance_valid(AGGRO_object):
		$NavigationAgent2D.target_position = AGGRO_object
	else:
		$NavigationAgent2D.target_position = global_position
	

func is_executable():
	if health / float(MAX_HEALTH) > THRESHOLD_PERCENTAGE:
		return false
	else:
		executable_object.set_is_executable(true)
		executable_object.set_origin(global_position)
		return true
func take_damage(amount):
	health -= amount
	current_state=States.STUNNED
	if health <= 0:
		queue_free()
	timer.start()
	
	
func fire():
	projectile_launcher.launch_projectiles_in_circle(AGGRO_object,10,150,0.0001,.30,335)
func return_IDLE():
	current_state = States.AGGRO
	attack_speed_cdn = ATTACK_SPEED
	

func _physics_process(delta: float) -> void:
	
	if is_instance_valid(executable_object):
		executable_object.set_origin(global_position)
	is_executable()
	match current_state:
		States.IDLE:
			if AGGRO_object != null:
				current_state = States.AGGRO
			move_and_friction(delta	)
		States.AGGRO:
			if AGGRO_object == null or !is_instance_valid(AGGRO_object):
				current_state = States.IDLE
				return_IDLE()
				return
			if global_position.distance_to(AGGRO_object.global_position) > 285:
				current_state = States.IDLE
				return_IDLE()
				return
			rotate(get_angle_to(AGGRO_object.global_position))
			attack_speed_cdn-=1
			if attack_speed_cdn < 1:
				attack_speed_cdn=ATTACK_SPEED
				current_state = States.ATTACKING
			if is_instance_valid(AGGRO_object):
				if is_instance_valid(nav_parent):
					move_towards_point(nav_parent.global_position, SPEED)
				else:
					pathfind_to_target($NavigationAgent2D, SPEED)
			else:
				print("No Pathfindable object (AGGRO_object) set, current value:",AGGRO_object)
			move_and_friction(delta)
		States.ATTACKING:
			current_state = States.AGGRO
			fire()
		States.STUNNED:
			move_and_friction(delta)

		
		
func _on_area_2d_body_entered(body: Player) -> void:
		AGGRO_object = body


func _on_timer_timeout() -> void:
	current_state= States.IDLE

func check_if_should_add_to_group(enemy:Enemy)->bool:
	if nav_group_children.size() < MAX_GROUP_SIZE and nav_parent==null:
		if enemy.nav_group_children.size() <= 0 and enemy.nav_parent == null: 
			# Infer if it is a child based on if it has no children and it has no parent
			return true
	else:
		return false
	return false
	
func scan_to_add_to_group()->void:
	var parent_found = false
	
	for i in navigation_grouper_area.get_overlapping_areas():
		var local_enemy = i.get_parent()
		if local_enemy == nav_parent:
			parent_found=true
		if local_enemy.is_in_group("enemies"):
			if check_if_should_add_to_group(local_enemy):
				nav_group_children.append(local_enemy)
				local_enemy.nav_parent = self
				break
	if !parent_found:
		nav_parent=null
			
func _on_nav_agent_recalculate_timeout() -> void:
	scan_to_add_to_group()
	if !is_instance_valid(nav_parent):
		if is_instance_valid(AGGRO_object):
			if $NavigationAgent2D.target_position != AGGRO_object.position:
				$NavigationAgent2D.target_position = AGGRO_object.global_position
	nav_agent_recalculate_timer.start(randf_range(0.7,1))
