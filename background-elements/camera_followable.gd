extends Node2D
class_name CameraFollowable
@export var player:Player
@export var camera:Camera2D
@export var is_visible:bool
enum states{
	DEFAULT,
	TRACKING_OBJECT,
}
@export var SPEED = 5

var state = states.DEFAULT
var base_radius = 20.0
var max_radius = 22.0
var radius = 10.0
var priority_map:Dictionary[Variant,int] = {
	Enemy:2,
	ZenithStar:1
}
var camera_tracker_dector:Area2D
var camera_tracker_un_dector:Area2D

@export var MAX_DISTANCE = 100
@export var tracking_object_list:Array[Node2D] = []
var current_tracking_object: Node2D = null

func _ready() -> void:
	if is_instance_valid(player):
		camera_tracker_dector = player.camera_tracker_dector
		camera_tracker_un_dector = player.camera_tracker_un_dector

		camera_tracker_dector.body_entered.connect(_on_body_entered)
		camera_tracker_un_dector.body_exited.connect(_on_body_exited)
		camera_tracker_dector.area_entered.connect(_on_area_entered)
		camera_tracker_un_dector.area_exited.connect(_on_area_exited)
		
func default_camera():
	var lerp_amount = 0.1
	#swap to tracking if object in list
	if tracking_object_list.size() > 0:
		state=states.TRACKING_OBJECT
		return
		
	if (!is_instance_valid(player) or !is_instance_valid(camera)):
		push_warning("Deleting CameraFollower as player or camera does not exist")
		queue_free()

	if (is_instance_valid(player.mouse_instance)):
		if player.velocity.length() > 110:
			radius = lerp(radius,max_radius,.1)
			lerp_amount = .4
		else:
			radius = lerp(radius,base_radius,.1)
			lerp_amount = .4

		var player_pos = player.global_position
		var mouse_pos = player.mouse_instance.global_position
		var dir = (mouse_pos - player_pos).normalized()
		var move_towards:Vector2 = player_pos + dir * radius
		global_position = global_position.lerp(move_towards,lerp_amount)
		
	else:
		global_position=player.global_position

func custom_sort_call(a,b):
	var map_keys = priority_map.keys()
	var a_in = a in map_keys
	var b_in = b in map_keys
	
	var a_distance = global_position.distance_to(a.global_position)
	var b_distance = global_position.distance_to(b.global_position)
	
	if !a_in and !b_in:
		return a_distance > b_distance

	if !a_in and b_in:
		return true
	
	if !b_in and a_in:
		return false	
	
	if priority_map[a] < priority_map[b]:
		return true
	if priority_map[a] == priority_map[b]:
		return a_distance > b_distance
	return false 
	
	
func tracking_object_camera():
	
	# clean list
	var deletables = []
	for i in tracking_object_list:
		if !is_instance_valid(i):
			deletables.append(i)

	for i in deletables:
		tracking_object_list.erase(i)
		
	# sort list
	tracking_object_list.sort_custom(custom_sort_call)
	# swap back to default camera work if not
	if tracking_object_list.size() < 1:
		state = states.DEFAULT
		return 
	#set object to max trackingobject
	var best = tracking_object_list[0]

	if current_tracking_object == null or !is_instance_valid(current_tracking_object):
		current_tracking_object = best
	else:
		var current_dist = global_position.distance_to(current_tracking_object.global_position)
		var best_dist = global_position.distance_to(best.global_position)

		if best != current_tracking_object and best_dist < current_dist - 10:
			current_tracking_object = best

	var tracking_object = current_tracking_object	
	var direction = tracking_object.global_position.direction_to(player.global_position)
	var distance = tracking_object.global_position.distance_to(player.global_position)
	var target_pos = tracking_object.global_position - ( direction *  distance)* -.8

	global_position= global_position.lerp(target_pos,.3)
	
	
	
func _process(delta: float) -> void:
	match state:
		states.DEFAULT:
			default_camera()
		states.TRACKING_OBJECT:
			tracking_object_camera()

func _on_body_entered(body: Node2D):
	if body and is_instance_valid(body):
		var parent = body.get_parent()
		if parent and parent.is_in_group("trackable_object"):
			if parent not in tracking_object_list:
				tracking_object_list.append(parent)


func _on_body_exited(body: Node2D):
	if body and is_instance_valid(body):
		var parent = body.get_parent()
		if parent:
			while parent in tracking_object_list:
				tracking_object_list.erase(parent)


func _on_area_entered(area: Area2D):
	if area and is_instance_valid(area):
		var parent = area.get_parent()
		if parent and parent.is_in_group("trackable_object"):
			if parent not in tracking_object_list:
				tracking_object_list.append(parent)


func _on_area_exited(area: Area2D):
	if area and is_instance_valid(area):
		var parent = area.get_parent()
		if parent:
			while parent in tracking_object_list:
				tracking_object_list.erase(parent)
