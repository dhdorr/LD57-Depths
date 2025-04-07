class_name UI extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var score: Label = $HBoxContainer/Score
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var animation_player: AnimationPlayer = $TextureRect/AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
#const SETTINGS_MENU = preload("res://Scenes/settings_menu.tscn")
@onready var obj_label: Label = $VBoxContainer/ObjList/ObjLabel

var objectives := ["Grab the Mint", "Grab the Smiley Pin", "Grab the Kisses", "Grab the Cherries"]
var score_val := 0

func _ready() -> void:
	SignalBus.update_score.connect(UpdateScore)
	SignalBus.do_confetti.connect(DoConfetti)
	SignalBus.do_warning.connect(DoWarning)
	SignalBus.restore_stamina.connect(RestoreStamina)
	SignalBus.adjust_sfx_volume.connect(AdjustSFX)
	SignalBus.update_objective.connect(UpdateObjective)
	#SignalBus.open_settings.connect(OpenSettings)

func UpdateObjective() -> void:
	var obj : String = objectives.pick_random()
	obj_label.text = obj
	if obj == "Grab the Mint":
		SignalBus.make_token.emit("mint")
	elif obj == "Grab the Smiley Pin":
		SignalBus.make_token.emit("smile")
	elif obj == "Grab the Kisses":
		SignalBus.make_token.emit("kiss")
	else:
		SignalBus.make_token.emit("cherry")

func Consume_Stamina(weight: float, mass: float) -> void:
	var final_weight := mass / 100
	progress_bar.value -= 1 * final_weight * get_physics_process_delta_time()
	if progress_bar.value <= 0.0:
		SignalBus.do_tired.emit()

func UpdateScore(value : int) -> void:
	score_val += value
	score.text = str(score_val)

func DoConfetti() -> void:
	cpu_particles_2d_2.emitting = true
	cpu_particles_2d.emitting = true
	audio_stream_player_2d.play(0.8)

func DoWarning() -> void:
	animation_player.play("wrong-item")

func RestoreStamina(value: int) -> void:
	progress_bar.value += value

func AdjustSFX(value: float) -> void:
	audio_stream_player_2d.volume_db = (value - 100.0) / 5.0
