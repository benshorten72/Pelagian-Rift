extends Node2D
class_name MouseObject
@onready var shape = $Area2D/CollisionShape2D
@onready var circle = shape.shape
@onready var circle_radius = circle.radius
var min_radius = 30.0
var executables_list:Array[ExecutableObject] = []
const EXECUTABLE_THRESHOLD = .30

func enemy_executed():
	circle.radius  = circle.radius*.25+circle.radius;

func get_valid_executables():
	var return_list:Array[ExecutableObject] = []
	for i in executables_list:
			if is_instance_valid(i) and i.is_executable:
				return_list.append(i)
	return return_list

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if circle.radius > min_radius:
		circle.radius  = lerp(circle.radius,min_radius,.009);
	else:
		circle.radius = min_radius
		


func _on_area_2d_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	print("HII",area.get_parent(),area.get_parent() is ExecutableObject )
	if area and area.get_parent() and area.get_parent() is ExecutableObject:
			executables_list.append(area.get_parent())

func _on_area_2d_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area and area.get_parent():
		var parent = area.get_parent()
		var executable_child = parent.get_node_or_null("ExecutableObject")
		
		if executable_child and executable_child in executables_list:
			executables_list.erase(executable_child)
