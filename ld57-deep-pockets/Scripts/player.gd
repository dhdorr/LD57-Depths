extends Node2D

@onready var picker_area: Area2D = $PickerArea
var PickedBody : RigidBody2D
var IsGrabbing = false
var velocity := Vector2.ZERO
var max_speed := 300

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	#InputEventMouseMotion.relative
	var v_siz = get_viewport_rect().size
	print("v_size: ", v_siz)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("escape_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	var m_pos = get_viewport().get_mouse_position()
	var test = (get_viewport_rect().size / 2) - m_pos
	
	var dist := Vector2.ZERO.distance_to(test)
	var dir := test.direction_to(Vector2.ZERO)
	
	if dist < 30:
		max_speed = 0
	else:
		max_speed = 300
	var desired_velocity := max_speed * dir
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * 10.0 * delta
	self.position += velocity * delta
	
	
	if IsGrabbing:
		var bdir := PickedBody.position.direction_to(picker_area.position)
		var bdist := PickedBody.position.distance_to(picker_area.position)
		var bdist2 := PickedBody.position.distance_squared_to(picker_area.position)
		
		PickedBody.linear_velocity = bdir * bdist2 * delta


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grab"):
		var bodies = picker_area.get_overlapping_bodies()
		for bs in picker_area.get_overlapping_bodies():
			if bs.is_in_group("obj"):
				IsGrabbing = true
				PickedBody = bs
				PickedBody.reparent(self, true)
				var dir = PickedBody.position.direction_to(picker_area.position)
				print("dir to hand: ", dir)
				var dist = PickedBody.position.distance_to(picker_area.position)
				print("dist to hand: ", dist)
				var dist2 = PickedBody.position.distance_squared_to(picker_area.position)
				PickedBody.linear_velocity = dir * dist2 * get_process_delta_time()
				break
	if event.is_action_released("grab"):
		IsGrabbing = false
		var dist2 = PickedBody.position.distance_squared_to(picker_area.position)
		var dist = PickedBody.position.distance_to(picker_area.position)
		var dir = PickedBody.position.direction_to(picker_area.position)
		#PickedBody.apply_central_impulse((dir + Vector2.UP) * dist2 * 100 * get_process_delta_time())
		print(PickedBody.linear_velocity)
		PickedBody.apply_central_impulse(PickedBody.linear_velocity * 100 * get_process_delta_time())
		PickedBody.reparent(get_tree().root)
