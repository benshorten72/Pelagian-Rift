extends Control
class_name GlobalComboObjectClass
@onready var queue_pop:Timer = $QueuePop
@export var combo_queue_max:int = 10
@export var queue_pop_time:float = 1.0
@export var minimum_refresh_time = 1.0

enum COMBO_POSSIBILITIES {kill,attack, dodge, perfect_dodge, execute, execute_aoe_kill}
var combo_values:Dictionary = {
	"kill":400,
	"attack": 100,
	"dodge":40,
	"perfect_dodge":60,
	"execute":410,
	"execute_aoe_kill":425
}
var combo_queue:Array[COMBO_POSSIBILITIES] = []
var combo_counter: Dictionary = {}
var combo_human_readable: Dictionary
func _ready() -> void:
	queue_pop.wait_time=queue_pop_time
	for i in COMBO_POSSIBILITIES.values():
		combo_counter[i] = []
	print(combo_counter)
		
func _on_queue_pop_timeout() -> void:
	print("pop")
	for i in combo_counter.keys():
		combo_human_readable[i] = combo_counter.values()[i] 
		if len(combo_counter[i]) > 0:
			var most_recent_combo_counter =  Time.get_ticks_msec() -combo_counter[i][0]["time_added"]
			if most_recent_combo_counter > minimum_refresh_time * 1000:
				combo_counter[i].clear()


func add_to_queue(combo_possibility:COMBO_POSSIBILITIES):
		combo_queue.append(combo_possibility)
		combo_counter[combo_possibility].append({"time_added":Time.get_ticks_msec()})
		combo_counter[combo_possibility].sort_custom(func(a,b):return a["time_added"] > b["time_added"])
		combo_queue=combo_queue.filter(func(i):return combo_possibility != i)
		combo_queue.append(combo_possibility)
		for i in combo_counter.keys():
			print(combo_values.keys()[i],":",len(combo_counter[i]))
			
		
