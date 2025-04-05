extends RigidBody2D

var StateGrabbed = false

func _on_area_2d_mouse_entered() -> void:
	print("mouse entered shape...")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("grab"):
		print("shape grabbed")
		StateGrabbed = true
		self.freeze = true
	

func _physics_process(delta: float) -> void:
	if StateGrabbed:
		var test = self.position.distance_to(get_viewport().get_mouse_position())
		print(test)
		if self.position.distance_to(get_viewport().get_mouse_position()) > 1.5:
			self.move_and_collide(self.position.direction_to(get_viewport().get_mouse_position()) * 2)
	

func _input(event: InputEvent) -> void:
	if StateGrabbed and event.is_action_released("grab"):
		print("shape dropped")
		StateGrabbed = false
		self.freeze = false
