extends Node2D
@onready var area_2d: Area2D = $Area2D
var isRecharged = true
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const consume_sfx := preload("res://Assets/Magic Crit A.wav")
const respawn_sfx := preload("res://Assets/Gulp.wav")

func _ready() -> void:
	SignalBus.adjust_sfx_volume.connect(AdjustSFX)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not isRecharged:
		return
	SignalBus.restore_stamina.emit(25)
	audio_stream_player_2d.stream = consume_sfx
	audio_stream_player_2d.play()
	self.visible = false
	isRecharged = false
	var timer := get_tree().create_timer(3.0)
	timer.timeout.connect(RespawnOrb)

func AdjustSFX(value: float) -> void:
	audio_stream_player_2d.volume_db = (value - 100.0) / 5.0


func RespawnOrb() -> void:
	audio_stream_player_2d.stream = respawn_sfx
	audio_stream_player_2d.play()
	self.visible = true
	isRecharged = true
