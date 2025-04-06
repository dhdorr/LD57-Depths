extends CharacterBody2D

@onready var picker_area: Area2D = $Hand/PickerArea
@onready var ui: UI = $UI
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var mouse_slowdown_area: Area2D = $Hand/MouseSlowdownArea
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $Hand/AudioStreamPlayer2D
const drop_sfx := preload("res://Assets/blip-1.wav")
const grab_sfx_1 := preload("res://Assets/Rustle A.wav")
const grab_sfx_2 := preload("res://Assets/Card Take 004.wav")

var PickedBody : RigidBody2D
var IsGrabbing = false
#var velocity := Vector2.ZERO
var max_speed := 200


func _ready() -> void:
	SignalBus.do_tired.connect(DoTired)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	SignalBus.adjust_sfx_volume.connect(AdjustSFX)
	#InputEventMouseMotion.relative
	var v_siz = get_viewport_rect().size

func AdjustSFX(value: float) -> void:
	audio_stream_player_2d.volume_db = (value - 100.0) / 5.0

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("escape_mouse"):
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var m_pos := get_viewport().get_mouse_position()
	var adjusted_m_pos := (get_viewport_rect().size / 2) - m_pos
	#adjusted_m_pos.y += picker_area.position.y
	
	#var dist := Vector2.ZERO.distance_to(adjusted_m_pos)
	#var dir := adjusted_m_pos.direction_to(Vector2.ZERO)
	
	var dist := picker_area.position.distance_to(adjusted_m_pos)
	
	#var dir := adjusted_m_pos.direction_to(picker_area.position)
	var dir := -mouse_slowdown_area.position.direction_to(adjusted_m_pos)
	
	if dist < 70:
		max_speed = 0
	else:
		max_speed = 200
	
	if IsGrabbing and PickedBody != null:
		if self.global_position.y > PickedBody.global_position.y + 70:
			if dir.y < 0:
				max_speed = 200
			else:
				max_speed = 0
		elif self.global_position.y < PickedBody.global_position.y - 70:
			if dir.y > 0:
				max_speed = 200
			else:
				max_speed = 0
		if self.global_position.x > PickedBody.global_position.x + 70:
			if dir.x < 0:
				max_speed = 200
			else:
				max_speed = 0
		elif self.global_position.x < PickedBody.global_position.x - 70:
			if dir.x > 0:
				max_speed = 200
			else:
				max_speed = 0
	
	var desired_velocity := (max_speed * dist / 100) * dir
	desired_velocity = desired_velocity.clamp(Vector2(-1000.0, -1000.0).normalized() * 1000.0, Vector2(1000.0, 1000.0).normalized() * 1000.0)
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * 10.0 * delta
	#self.position += velocity * delta
	move_and_slide()
	
	
	if IsGrabbing and PickedBody != null:
		var bdir := PickedBody.global_position.direction_to(picker_area.global_position)
		var bdist := PickedBody.global_position.distance_to(picker_area.global_position)
		var bdist2 := PickedBody.global_position.distance_squared_to(picker_area.global_position)
		
		var desired_velocity2 := ((bdist2 / PickedBody.mass) + (300 * 2)) * bdir
		if bdist < 10.0:
			desired_velocity2 = Vector2.ZERO
		var steering_vector2 := desired_velocity2 - PickedBody.linear_velocity
		PickedBody.linear_velocity += steering_vector2 * 10.0 * delta
		
		# update stamina bar
		ui.Consume_Stamina(0, PickedBody.mass)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		animation_player.play("HandGrab")
		var bodies = picker_area.get_overlapping_bodies()
		for bs in picker_area.get_overlapping_bodies():
			if bs.is_in_group("obj"):
				IsGrabbing = true
				audio_stream_player_2d.stream = grab_sfx_2
				audio_stream_player_2d.play(0.18)
				if bs.is_in_group("token"):
					SignalBus.flip_arrow.emit()
				PickedBody = bs
				#PickedBody.reparent(self, true)
				PickedBody.gravity_scale = 0
				return
		audio_stream_player_2d.stream = grab_sfx_1
		audio_stream_player_2d.play()
	if event.is_action_released("grab"):
		DoTired()
		#PickedBody.reparent(get_tree().root)

func DoTired() -> void:
	animation_player.play("HandGrab", -1, -1.0, true)
	IsGrabbing = false
	audio_stream_player_2d.stream = drop_sfx
	audio_stream_player_2d.play()
	
	if PickedBody == null:
		return
	PickedBody.gravity_scale = 1
	PickedBody.apply_central_impulse(PickedBody.linear_velocity * 100 * get_process_delta_time())


func _on_mouse_slowdown_area_mouse_entered() -> void:
	max_speed = 0


func _on_mouse_slowdown_area_mouse_exited() -> void:
	max_speed = 300
