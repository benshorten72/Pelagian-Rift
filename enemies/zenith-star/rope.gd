extends Line2D
class_name Rope

@export var segments := 11
@export var segment_length := 4.0
@export var gravity := Vector2(0, 20)
@export var is_parent_whackable=true
@onready var process_end_timer = $ProcessEndTimer
const MIN_WHACK_DISTANCE = 40
const regular_texture_path = "res://resources/sprites/enemies/chain-sheet.png"
const breaking_texture_path = "res://resources/sprites/enemies/chainbreak/chainbreak.png"

@onready var regular_texture:Texture2D = preload(regular_texture_path)
@onready var breaking_texture:Texture2D = preload(breaking_texture_path)

var points_pos: Array[Vector2] = []
var points_prev: Array[Vector2] = []
var parent: Node2D
var end_parent: Node2D
var mat := material as ShaderMaterial
var is_whacking = false
var is_connected_to_object = true
var is_disabling := false


func set_end_parent(end_parent_input):
	end_parent=end_parent_input

func create(end_parent_input):
	visible=false
	clear_points()
	for i in range(segments):
		add_point(parent.position)
	texture=regular_texture
	set_end_parent(end_parent_input)
	is_whacking = false


	visible = true
	
func disable():
	print("atempting to disabled")
	if !is_disabling:
		texture=breaking_texture
		material.set_shader_parameter("start_time", Time.get_ticks_msec() / 1000.0)
		print("Setting timer")

		process_end_timer.start(.4)
		print(texture)
		is_disabling=true


func looking_to_whack():
	if is_parent_whackable:
		for i in range((round(points_pos.size()/2)),points_pos.size()):
			if is_instance_valid(parent):
				if points_pos[i].distance_to(parent.global_position) < MIN_WHACK_DISTANCE:
						parent.whack()

				
func _ready():
	mat.set_shader_parameter("repeats",segments)
	parent = get_parent()
	var start = parent.global_position

	for i in range(segments):
		points_pos.append(start + Vector2(0, i * segment_length))
		points_prev.append(points_pos[i])
	
	clear_points()
	for i in range(segments):
		add_point(Vector2.ZERO)

func _process(delta):
	if is_whacking:
		looking_to_whack()
	var start = parent.global_position

	# lock first point
	points_pos[0] = start
	# Verlet integration
	for i in range(1, segments):
		var pos = points_pos[i]
		var prev = points_prev[i]

		points_prev[i] = pos
		points_pos[i] += (pos - prev) + gravity * delta * delta
		
		var end
		if is_instance_valid(end_parent):
			end = end_parent.global_position
			points_pos[segments - 1] = end
		else:
			end = null	

		
	for _j in range(1): # iterations = stiffness
		solve_constraints(start)

	# draw
	for i in range(segments):
		points[i] = to_local(points_pos[i])
	
	queue_redraw()
func solve_constraints(start_pos: Vector2):
	points_pos[0] = start_pos

	for i in range(segments - 1):
		var p1 = points_pos[i]
		var p2 = points_pos[i + 1]

		var delta = p2 - p1
		var dist = delta.length()
		var diff = (dist - segment_length) / dist if dist != 0 else 0

		var offset = delta * 0.5 * diff

		if i != 0:
			points_pos[i] += offset
		points_pos[i + 1] -= offset

func activate_whacking():
	print("Rope looking to whack")
	is_whacking = true

func push(push_from_point:Vector2, strength:float):
	is_connected_to_object=false
	for i in range(segments-1):
		var offset = points_pos[i] - push_from_point
		var distance = offset.length()
		if distance < 100:
			var force = strength * (1.0 - distance / 100.0)
			points_pos[i] += offset.normalized() * force
			

func end_process():
	visible=false
	set_process(false)

func _on_process_end_timer_timeout() -> void:
	print("process_ended")
	end_process()
