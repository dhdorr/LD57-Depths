extends Node2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	var score := 0
	if body.is_in_group("token"):
		score = 1000000
		print("you did it!")
		SignalBus.do_confetti.emit()
	else:
		score = randi_range(-1000, -10000)
		SignalBus.do_warning.emit()
	SignalBus.update_score.emit(score)
	body.queue_free()
