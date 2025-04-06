extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		self.set_process_input(false)
		audio_stream_player_2d.play()
		self.visible = false
		SignalBus.start_level.emit()


func _on_audio_stream_player_2d_finished() -> void:
	self.queue_free()
