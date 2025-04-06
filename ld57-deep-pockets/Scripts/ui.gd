class_name UI extends Control

@onready var progress_bar: ProgressBar = $ProgressBar


func Consume_Stamina(weight: float, mass: float) -> void:
	#var final_weight = mass
	#if weight > 50 && 100 > weight:
		#final_weight = mass + 75
	#elif weight > 100 && 150 > weight:
		#final_weight = mass + 125
	#elif weight > 150 && 200 > weight:
		#final_weight = mass + 175
	#elif weight > 200 && 300 > weight:
		#final_weight = mass + 250
	#elif weight > 300 && 1000 > weight:
		#final_weight = mass + 500
	
	#progress_bar.value -= final_weight / 50 * get_physics_process_delta_time()
	var final_weight := mass / 10
	progress_bar.value -= 1 * final_weight * get_physics_process_delta_time()
