extends Line2D
@export var MAX_QUEUE_LENGTH = 5
@export var smallestTipWidth = 1
@export var largestTipWidth = 2

var queue: Array[Vector2] = []
var parent:Node2D
var offset:Vector2 = Vector2(0,0)

func _ready() -> void:
	if is_instance_valid(get_parent()):
		parent = get_parent().get_parent().get_parent()
		print("Water trail ready")
	else:
		queue_free()

func _process(delta: float) -> void:
	var pos:Vector2 = parent.global_position + offset
	queue.push_back(pos)
	if(queue.size() > MAX_QUEUE_LENGTH):
		queue.pop_front()
	
	clear_points()
	var total_length:float = 0.0
	for i in range(queue.size() - 1):
		add_point(parent.to_local(queue[i]))
		total_length += queue[i].distance_to(queue[i + 1])
	add_point(parent.to_local(queue[-1]))

	var true_min = INF
	var true_max = -INF

	var widthValue:float  = lerpf(smallestTipWidth, largestTipWidth, 
	inverse_lerp(0, queue.size(),total_length))
	width_curve.set_point_value(0, widthValue)
