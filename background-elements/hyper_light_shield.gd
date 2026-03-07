extends Area2D
class_name HyperionLightShield
var enabled:= true
@export var facing_matters = true
@onready var collision_box:= $CollisionShape2D

func check_is_facing(attacking_from_global_position:Vector2, verbose=false):
	if !facing_matters:
		return false
	
	var to_attacker = (attacking_from_global_position - global_position).normalized()
	var forward = global_transform.basis_xform(Vector2.DOWN)

	var dot = forward.dot(to_attacker)
	if dot > 0.5:
		if verbose: print("Shield is facing attacker!")
		return true
	else:
		if verbose: print("Shield is not facing attacker!")
		return false


func set_enabled(value:bool):
	if !value:
		enabled= false
		set_collision_layer_value(2,false)
		set_collision_mask_value(2,false)
		
	else:
		enabled= true
		set_collision_layer_value(2,true)
		set_collision_mask_value(2,true)
