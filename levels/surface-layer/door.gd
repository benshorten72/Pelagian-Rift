extends StaticBody2D
@onready var animation_player = $AnimationPlayer
enum OPTIONS {left,right}
@export var vertical:bool = false
@export var open_direction = OPTIONS.left
@export var encounter:Encounter = null
func _ready() -> void:
	if vertical:
		rotate(90)
	if encounter:
		encounter.encounter_over.connect(open_door)

func open_door():
	if open_direction == OPTIONS.left:		
		animation_player.play("open_left")
	else:
		animation_player.play("open_right")
