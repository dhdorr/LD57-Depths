extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		SignalBus.start_level.emit()
		self.queue_free()
