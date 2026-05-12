extends Node2D
class_name Wave
signal wave_completed

enum WaveType { WITH_REPLACE, TIMED, WITH_REPLACE_TIMED }
#With replace = when currently alive dips below with_replace_spawn_max, spawn more from list
#With replace = when currently alive dips below 

@export var with_replace_spawn_max = 1
@export var time_between_spawn:float = 1.0
@export var batch_amount = 1
@export var state:WaveType
@export var time_between_consecutive_spawns = .3
var enemy_spawn_point_list:Array[EnemySpawnPoint] = []

@export var enemy_list:Array[PackedScene] = []
var spawned_enemies:Array[Node2D] = []
@export var spawn_radius: float = 5.0

@onready var detector: Area2D = $Area2D

func _ready() -> void:
	await get_tree().process_frame
	for area in detector.get_overlapping_areas():
		if area is EnemySpawnPoint:
			enemy_spawn_point_list.append(area as EnemySpawnPoint)
			
func get_whos_alive(enemy_list:Array[Node2D]) -> Array[Node2D]:
	var alive:Array[Node2D] = []
	
	for enemy in enemy_list:
		if is_instance_valid(enemy):
			alive.append(enemy)
			
	return alive
func start_wave():
	while enemy_list.size() > 0:
		match state:
			WaveType.WITH_REPLACE:
				await with_replace()

			WaveType.TIMED:
				await timed()

			WaveType.WITH_REPLACE_TIMED:
				await with_replace_time_between()

		await get_tree().process_frame
	while get_whos_alive(spawned_enemies).size() > 0:
		await get_tree().process_frame

	print("Wave completed")
	wave_completed.emit()

func spawn_enemy(limit=999):
	print("attempting to spawn enemies")
	if batch_amount==0:
		push_warning("Batch is 0, not spawning")
		return
#		use batch amount to decide how many enemies are spawning
	spawned_enemies = get_whos_alive(spawned_enemies)
	var amount = min(batch_amount, enemy_list.size())
	
	if (amount + spawned_enemies.size()) >= limit:
		amount = max(0, limit - spawned_enemies.size())
		
	var spawnables:Array[PackedScene] = enemy_list.slice(0, amount)
	enemy_list = enemy_list.slice(amount)
	for i in spawnables:
		var spawn_point = enemy_spawn_point_list.pick_random()
		var enemy := i.instantiate() as Node2D
		add_child(enemy)
		var random_offset = Vector2(
			randf_range(-spawn_radius, spawn_radius),
			randf_range(-spawn_radius, spawn_radius)
		)

		enemy.global_position = spawn_point.global_position + random_offset
		spawned_enemies.append(enemy)
		await get_tree().create_timer(time_between_consecutive_spawns).timeout
		print("going to spawn:",enemy.global_position)
		
func wait_time_between():
	await get_tree().create_timer(time_between_spawn).timeout

func with_replace():
	await spawn_enemy(with_replace_spawn_max)
		
func timed():
	await wait_time_between()
	await spawn_enemy()

func with_replace_time_between():
	await wait_time_between()
	await spawn_enemy(with_replace_spawn_max)
		
