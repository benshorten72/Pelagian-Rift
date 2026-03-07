extends ProgressBar

@onready var parent:Enemy = get_parent()
@export var bar_scale := 8
var executable_object:ExecutableObject

func _ready() -> void:
	max_value=parent.MAX_HEALTH
	min_value=0
	scale= scale/bar_scale
	executable_object = parent.get_executable_object()

func _physics_process(delta: float) -> void:
	value=parent.health
	if executable_object.is_executable:
		modulate = Color(1,.5,.5,1)
