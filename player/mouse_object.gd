extends Node2D
@onready var shape = $Area2D/CollisionShape2D
@onready var circle = shape.shape
@onready var circle_radius = circle.radius
var min_radius = 30.0
var valid_enemies_list = []
const EXECUTABLE_THRESHOLD = .30

func enemy_executed():
	circle.radius  = circle.radius*.25+circle.radius;

func _on_area_2d_body_entered(body: Node2D) -> void:
	valid_enemies_list.append(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	valid_enemies_list.erase(body)

func get_valid_enemies():
	
	var return_list = []
	
	for i in valid_enemies_list:
		if i.is_in_group("enemies"):
			var enemy_executable = i.is_executable()
			if enemy_executable:
				return_list.append(i)
				
	return return_list

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if circle.radius > min_radius:
		circle.radius  = lerp(circle.radius,min_radius,.009);
	else:
		circle.radius = min_radius
		
