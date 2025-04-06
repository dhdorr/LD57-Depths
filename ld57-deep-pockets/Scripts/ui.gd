class_name UI extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var score: Label = $HBoxContainer/Score
@onready var cpu_particles_2d_2: CPUParticles2D = $CPUParticles2D2
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var animation_player: AnimationPlayer = $TextureRect/AnimationPlayer

var score_val := 0

func _ready() -> void:
	SignalBus.update_score.connect(UpdateScore)
	SignalBus.do_confetti.connect(DoConfetti)
	SignalBus.do_warning.connect(DoWarning)
	SignalBus.restore_stamina.connect(RestoreStamina)

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

func DoWarning() -> void:
	animation_player.play("wrong-item")

func RestoreStamina(value: int) -> void:
	progress_bar.value += value
