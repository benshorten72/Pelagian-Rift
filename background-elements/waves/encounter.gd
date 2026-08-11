extends Node2D

class_name Encounter

signal encounter_start
signal encounter_over

@export var start_on_detection = true
@export var start_on_ready = false
@onready var detection_area = $Area2D
var started = false
var waves:Array[Wave] = []

func _ready() -> void:
	
	await get_tree().process_frame

	for child in get_children():
		if child is Wave:
			waves.append(child)

	if start_on_ready:
		start_encounter()
		encounter_over.emit()

func start_encounter() -> void:
	started=true
	for wave in waves:
		print("Starting wave", wave)
		wave.start_wave()
		await wave.wave_completed
	print("Encounter complete")
	encounter_over.emit()

func _on_area_2d_body_entered(body: Player) -> void:
	print("player entered")
	if body and start_on_detection and started==false:
		start_encounter()
		encounter_start.emit()
		
