extends RigidBody3D

var grabbed = false

func _physics_process(delta: float) -> void:
	var collision = self.move_and_collide(self.linear_velocity * delta, true)
	if collision:
		self.linear_velocity = self.linear_velocity.bounce(collision.get_normal())
		print(self.linear_velocity)
	if grabbed:
		self.linear_velocity = Vector3.ZERO
		
		var m_x = get_viewport().get_mouse_position().x
		var m_y = get_viewport().get_mouse_position().y
		var t_v = Vector3(self.position.x, self.position.y, self.position.z)
		var t_dir = t_v.direction_to(Vector3(self.position.x, m_y, self.position.z))
		var t_dist = t_v.distance_to(Vector3(self.position.x, m_y, self.position.z))
		#var dir1 = self.position.direction_to(Vector3(m_x, m_y, self.position.z))
		#var dist = self.position.distance_to(Vector3(m_x, m_y, self.position.z))
		#self.move_and_collide(t_dir * t_dist * delta)
		self.position = Vector3(self.position.x, m_y, self.position.z)


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print("picked")
	if event.is_action_pressed("grab"):
		grabbed = true


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print("picked2")
	if event.is_action_pressed("grab"):
		grabbed = true
