extends RigidBody2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
var isWaiting := false
var waitTime := 0.1

func _ready() -> void:
	SignalBus.adjust_sfx_volume.connect(AdjustSFX)

func AdjustSFX(value: float) -> void:
	audio_stream_player_2d.volume_db = (value - 100.0) / 5.0

func _on_body_entered(body: Node) -> void:
	if isWaiting:
		return
	isWaiting = true
	var timer = get_tree().create_timer(waitTime).timeout.connect(ResetWaiting)
	audio_stream_player_2d.play()
	

func ResetWaiting() -> void:
	isWaiting = false
