extends Node2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_music_slider_value_changed(value: float) -> void:
	SignalBus.adjust_music_volume.emit(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SignalBus.adjust_sfx_volume.emit(value)


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/home_screen.tscn")


func _on_texture_button_pressed() -> void:
	SignalBus.resume_game.emit()
	self.queue_free()
