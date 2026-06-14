extends CanvasLayer

@export var player:Player
@export var progressbar:ProgressBar
@onready var fpsText = $Gui/RichTextLabel
func _ready() -> void:
	if is_instance_valid(player):
		progressbar.max_value=player.MAX_HEALTH
		progressbar.min_value=0
	else:
		queue_free()
func _process(delta: float) -> void:
	fpsText.text = "fps: "+ str(Engine.get_frames_per_second() )
	if is_instance_valid(player):
		progressbar.value=player.health
	else:
		queue_free()
