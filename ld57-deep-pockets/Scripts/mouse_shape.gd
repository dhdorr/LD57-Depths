extends StaticBody2D

func _physics_process(delta: float) -> void:
	self.position = get_viewport().get_mouse_position()
