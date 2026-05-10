extends CanvasLayer

@export var player:Player
@export var progressbar:ProgressBar

func _ready() -> void:
	if is_instance_valid(player):
		progressbar.max_value=player.MAX_HEALTH
		progressbar.min_value=0
	else:
		queue_free()
func _process(delta: float) -> void:
	if is_instance_valid(player):
		progressbar.value=player.health
	else:
		queue_free()
