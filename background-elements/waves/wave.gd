extends Node2D
class_name Wave

signal wave_completed


var enemy_spawn_point_list: Array[EnemySpawnPoint] = []
var available_enemies: Array[Node2D] = []
var spawned_enemies: Array[Node2D] = []

@export var wave_data: WaveData
@export var verbose:bool = false

@onready var detector: Area2D = $Area2D

func _ready() -> void:
	for child in get_children():
		if child is not EnemySpawnPoint:
			child.visible = false
			child.process_mode = Node.PROCESS_MODE_DISABLED
			
func init() -> void:
	# Cache child enemies and disable them
	for child in get_children():
		if child is EnemySpawnPoint:
			enemy_spawn_point_list.append(child)

		else:
			available_enemies.append(child)
			child.visible = false
			child.process_mode = Node.PROCESS_MODE_DISABLED
	if verbose: print("Enemies:",available_enemies, "SpawnPointaL",enemy_spawn_point_list)
func get_whos_alive(enemy_list: Array[Node2D]) -> Array[Node2D]:
	var alive: Array[Node2D] = []

	for enemy in enemy_list:
		if enemy != null and is_instance_valid(enemy):
			alive.append(enemy)

	return alive

func start_wave():
	init()
	while available_enemies.size() > 0:
		match wave_data.state:
			wave_data.WaveType.WITH_REPLACE:
				await with_replace()

			wave_data.WaveType.TIMED:
				await timed()

			wave_data.WaveType.WITH_REPLACE_TIMED:
				await with_replace_time_between()

		await get_tree().process_frame
	while get_whos_alive(spawned_enemies).size() > 0:
		spawned_enemies = get_whos_alive(spawned_enemies)
		
		await get_tree().process_frame

	if verbose: print("Wave completed")
	wave_completed.emit()

func spawn_enemy(limit = 999):
	if verbose: print("attempting to spawn enemies")
	if enemy_spawn_point_list.size() == 0:
		push_warning("No Spawn points for !!!!!",self.name)
		return
	if wave_data.batch_amount == 0:
		push_warning("Batch is 0, not spawning")
		return

	spawned_enemies = get_whos_alive(spawned_enemies)

	var amount = min(wave_data.batch_amount, available_enemies.size())

	var remaining_slots = limit - spawned_enemies.size()
	amount = min(amount, remaining_slots)

	if amount <= 0:
		return

	var spawnables: Array[Node2D] = available_enemies.slice(0, amount)
	available_enemies = available_enemies.slice(amount)
	for enemy in spawnables:
		var spawn_point = enemy_spawn_point_list.pick_random()

		var random_offset = Vector2(
			randf_range(-wave_data.spawn_radius, wave_data.spawn_radius),
			randf_range(-wave_data.spawn_radius, wave_data.spawn_radius)
		)
		
		enemy.global_position = spawn_point.global_position + random_offset
		if verbose: print("global position: ",enemy.global_position)
		enemy.visible = true
		enemy.process_mode = Node.PROCESS_MODE_INHERIT

		spawned_enemies.append(enemy)

		await get_tree().create_timer(
			wave_data.time_between_consecutive_spawns
		).timeout


func wait_time_between():
	await get_tree().create_timer(wave_data.time_between_spawn).timeout

func with_replace():
	await spawn_enemy(wave_data.with_replace_spawn_max)

func timed():
	await wait_time_between()
	await spawn_enemy()

func with_replace_time_between():
	await wait_time_between()
	await spawn_enemy(wave_data.with_replace_spawn_max)
