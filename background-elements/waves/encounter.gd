extends Node2D
class_name Encounter

signal encounter_over

var waves:Array[Wave] = []

func _ready() -> void:
	await get_tree().process_frame

	for child in get_children():
		if child is Wave:
			waves.append(child)
	start_encounter()

func start_encounter() -> void:
	for wave in waves:
		print("Starting wave", wave)
		wave.start_wave()
		await wave.wave_completed
	
	print("Encounter complete")
	encounter_over.emit()
