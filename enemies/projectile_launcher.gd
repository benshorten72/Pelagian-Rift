extends Node2D
class_name ProjectileLauncher
var bulletScene = preload("res://enemies/bullet.tscn")
@onready var timer:Timer = $Timer
@export var target:Node2D

func launch_projectiles_in_circle(
	target:Node2D,
	bullet_amount:int,
	speed=10,
	delay:float=0.1,
	shoot_circle_amount:float=1,
	start_angle:float=0
):
	if bullet_amount <= 0:
		return

	var angle_step = TAU * shoot_circle_amount / bullet_amount
	var base_angle = global_rotation + deg_to_rad(start_angle)

	for i in range(bullet_amount):
		timer.start(delay)
		await timer.timeout

		var angle = base_angle + angle_step * i
		var direction = Vector2.RIGHT.rotated(angle)

		var bullet_instance = ProjectileStoreGlobal.get_bullet()
		bullet_instance.enable()
		bullet_instance.global_position = global_position
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.init(target.global_position, direction, speed)
	
func launch_projectiles_in_line(target:Node2D, bullet_amount:int,speed=10,delay:float=0.1):
	if bullet_amount <= 0:
		print("Why fire 0 bullets ?")
		return
		
	var position_to_target = target.global_position

	for i in bullet_amount:
		timer.start(delay)
		await timer.timeout
		var bullet_instance:Bullet = ProjectileStoreGlobal.get_bullet()
		
		bullet_instance.enable()
		bullet_instance.global_position=global_position
		get_tree().current_scene.add_child(bullet_instance)
		bullet_instance.init(position_to_target,null, speed)
		
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed:
		#print("Launched")
		#launch_projectiles_in_circle(target, 20, 4, 0.0000000001, 1)
