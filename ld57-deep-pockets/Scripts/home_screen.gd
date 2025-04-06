extends Node2D
@onready var audio_stream_player: AudioStreamPlayer = $"Pocket-2/Node/TextureButton/AudioStreamPlayer"
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_texture_button_pressed() -> void:
	audio_stream_player.play()
	animation_player.play("fade")
	#audio_stream_player.finished.connect(ChangeScene)

func ChangeScene() -> void:
	get_tree().change_scene_to_file("res://Scenes/world_1.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		ChangeScene()
