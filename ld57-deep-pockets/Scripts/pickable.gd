extends RigidBody2D

var StateGrabbed = false

func _on_area_2d_mouse_entered() -> void:
	print("mouse entered shape...")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("grab"):
		print("shape grabbed")
		StateGrabbed = true
		self.gravity_scale = 0
		#self.freeze = true
	

func _physics_process(delta: float) -> void:
	if StateGrabbed:
		
		var distance2 = self.position.distance_squared_to(get_viewport().get_mouse_position())
		var distance1 = self.position.distance_to(get_viewport().get_mouse_position())
		var direction = self.position.direction_to(get_viewport().get_mouse_position())
		var collision = self.move_and_collide(direction * distance1, true)
		
		#self.move_and_collide(direction * distance1 / 20)
		self.linear_velocity = direction * distance1
	

func _input(event: InputEvent) -> void:
	if StateGrabbed and event.is_action_released("grab"):
		print("shape dropped")
		StateGrabbed = false
		self.gravity_scale = 1
		var distance2 = self.position.distance_squared_to(get_viewport().get_mouse_position())
		var distance1 = self.position.distance_to(get_viewport().get_mouse_position())
		var direction = self.position.direction_to(get_viewport().get_mouse_position())
		self.apply_central_impulse(direction * distance2)
