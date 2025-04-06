extends Node2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const bad_cheer = preload("res://Assets/Aww A.wav")
const good_cheer = preload("res://Assets/Woohoo A.wav")

func _ready() -> void:
	SignalBus.adjust_sfx_volume.connect(AdjustSFX)

func AdjustSFX(value: float) -> void:
	audio_stream_player_2d.volume_db = (value - 100.0) / 5.0



func _on_area_2d_body_entered(body: Node2D) -> void:
	var score := 0
	if body.is_in_group("token"):
		score = 1000000
		print("you did it!")
		SignalBus.do_confetti.emit()
		audio_stream_player_2d.stream = good_cheer
		audio_stream_player_2d.play()
	else:
		score = randi_range(-1000, -10000)
		SignalBus.do_warning.emit()
		audio_stream_player_2d.stream = bad_cheer
		audio_stream_player_2d.play()
	SignalBus.update_score.emit(score)
	body.queue_free()
