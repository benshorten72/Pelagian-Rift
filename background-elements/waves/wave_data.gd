extends Resource
class_name WaveData

enum WaveType { WITH_REPLACE, TIMED, WITH_REPLACE_TIMED }

@export var with_replace_spawn_max = 1
@export var time_between_spawn: float = 1.0
@export var batch_amount = 1
@export var state: WaveType

@export var time_between_consecutive_spawns = 0.3
@export var spawn_radius: float = 5.0
