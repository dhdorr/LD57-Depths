extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
const SETTINGS_MENU = preload("res://Scenes/settings_menu.tscn")

var settings_open = false

func _ready() -> void:
	player.set_process_input(false)
	player.set_physics_process(false)
	SignalBus.start_level.connect(StartLevel)
	SignalBus.adjust_music_volume.connect(AdjustMusicVolume)
	SignalBus.resume_game.connect(ResumeGame)
	

func StartLevel() -> void:
	player.set_process_input(true)
	player.set_physics_process(true)
	player.visible = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape_mouse"):
		if settings_open:
			return
		settings_open = true
		print("spawn menu")
		player.visible = false
		player.set_physics_process(false)
		SignalBus.open_settings.emit()
		var menu := SETTINGS_MENU.instantiate()
		add_child(menu)
		menu.position = player.position
		menu.top_level = true

func ResumeGame() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	settings_open = false
	player.visible = true
	player.set_physics_process(true)

func AdjustMusicVolume(value: float) -> void:
	audio_stream_player.volume_db = (value - 100.0) / 2.0
