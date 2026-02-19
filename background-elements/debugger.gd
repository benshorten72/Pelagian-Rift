extends Node2D
@onready var EnemyScene = preload("res://enemies/enemy.tscn")

func _input(event):
	if event.is_action_pressed("create_enemy"):
		var enemy = EnemyScene.instantiate()
		add_child(enemy)
		enemy.global_position = get_global_mouse_position()
