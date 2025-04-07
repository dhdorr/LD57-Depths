extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
const SETTINGS_MENU := preload("res://Scenes/settings_menu.tscn")
const CHERRY_CANDY := preload("res://Scenes/cherry-candy.tscn")
const KISSES_CANDY := preload("res://Scenes/kisses-candy.tscn")
const LONG_PICKABLE_OBJECT := preload("res://Scenes/long_pickable_object.tscn")
const MINT_CANDY := preload("res://Scenes/mint-candy.tscn")
const PHONE := preload("res://Scenes/phone.tscn")
const SMILES_CANDY := preload("res://Scenes/smiles-candy.tscn")
var settings_open = false

var stuff := [CHERRY_CANDY, KISSES_CANDY, MINT_CANDY, SMILES_CANDY]


func _ready() -> void:
	player.set_process_input(false)
	player.set_physics_process(false)
	SignalBus.start_level.connect(StartLevel)
	SignalBus.adjust_music_volume.connect(AdjustMusicVolume)
	SignalBus.resume_game.connect(ResumeGame)
	SignalBus.make_token.connect(MakeToken)
	

func MakeToken(name: String) -> void:
	for n in get_tree().get_nodes_in_group("token"):
		n.remove_from_group("token")
		
	var r := randi_range(0, 100)
	if r % 3 == 0:
		call_deferred("add_child", PHONE.instantiate())
	elif r % 2 == 0:
		call_deferred("add_child", LONG_PICKABLE_OBJECT.instantiate())
	
	for c in get_tree().get_nodes_in_group(name):
		c.add_to_group("token")
	
	for s in stuff:
		var t = s.instantiate()
		if t.is_in_group(name):
			t.add_to_group("token")
		call_deferred("add_child", t)
	

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
