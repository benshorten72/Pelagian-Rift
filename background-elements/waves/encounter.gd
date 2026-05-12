extends Node2D
class_name Encounter
signal encounter_over
@export var waves:Array[Wave] = []

func _ready() -> void:
	start_encounter()

func start_encounter() -> void:
	for wave in waves:
		print("Starting wave")

		await wave.start_wave()

	print("Encounter complete")
	encounter_over.emit()
