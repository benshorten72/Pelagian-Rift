extends Node2D
class_name ProjectileStore

var bulletScene = preload("res://enemies/bullet.tscn")
var bullets:Array[Bullet] = []
func _ready() -> void:
	repeatedly_spawn_bullet(bulletScene,100)

func repeatedly_spawn_bullet(scene:Resource, amount:int):
	for i in range(amount):
		var resource_instance:Bullet = scene.instantiate()
		resource_instance.set_process(false)
		bullets.append(resource_instance)

func add_to_bullet_array(bullet:Bullet):
	bullet.global_position = global_position
	bullets.append(bullet)
	
func get_bullet()->Bullet:
	if len(bullets) > 0:
		var obj= bullets.pop_front()
		if is_instance_valid(obj):
			return obj
	var resource_instance:Bullet = bulletScene.instantiate()
	return resource_instance

		
