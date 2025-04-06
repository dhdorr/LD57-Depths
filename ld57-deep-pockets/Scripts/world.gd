extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	player.set_process_input(false)
	player.set_physics_process(false)
	SignalBus.start_level.connect(StartLevel)
	

func StartLevel() -> void:
	player.set_process_input(true)
	player.set_physics_process(true)
	player.visible = true
