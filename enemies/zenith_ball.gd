extends Node2D
@onready var chain:Sprite2D = $Chain
@export var zenith_parent:CharacterBody2D
var aggro_object

func _ready() -> void:
	chain.region_rect.size = Vector2(32,100)
	chain.centered = false
	chain.region_rect.position = Vector2(0, 0)


func _physics_process(delta: float) -> void:
	aggro_object=zenith_parent.AGGRO_object
	if aggro_object:		
		global_position = aggro_object.global_position
		look_at(zenith_parent.global_position)
		rotate(deg_to_rad(270))
		chain.region_rect.size = Vector2(32,global_position.distance_to(zenith_parent.global_position))
