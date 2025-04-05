extends RigidBody2D
@onready var progress_bar: ProgressBar = $"../UI/ProgressBar"
@onready var ui: UI = $"../UI"

var StateGrabbed = false

func _ready() -> void:
	$Label.text = str(self.mass)


func _on_area_2d_mouse_entered() -> void:
	print("mouse entered shape...")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("grab"):
		print("shape grabbed")
		StateGrabbed = true
		self.gravity_scale = 0
		#self.freeze = true


func _physics_process(delta: float) -> void:
	pass
	#if StateGrabbed:
		#var distance2 = self.position.distance_squared_to(get_viewport().get_mouse_position())
		#var distance1 = self.position.distance_to(get_viewport().get_mouse_position())
		#var direction = self.position.direction_to(get_viewport().get_mouse_position())
		#var collision = self.move_and_collide(direction * distance1 * delta, true)
		#
		##self.move_and_collide(direction * distance1 / 20)
		#
		#self.linear_velocity = direction * distance2 * 2 * delta
		#
		#var weight = 0.0
		#if collision:
			#weight = Calculate_Weight(collision)
		#
		#ui.Consume_Stamina(weight, self.mass)


func _input(event: InputEvent) -> void:
	if StateGrabbed and event.is_action_released("grab"):
		print("shape dropped")
		StateGrabbed = false
		self.gravity_scale = 1
		var distance2 = self.position.distance_squared_to(get_viewport().get_mouse_position())
		var distance1 = self.position.distance_to(get_viewport().get_mouse_position())
		var direction = self.position.direction_to(get_viewport().get_mouse_position())
		self.apply_central_impulse(direction * distance1)


func Calculate_Weight(collision: KinematicCollision2D) -> float:
	var weight = 0.0
	for b in self.get_colliding_bodies():
		if b.is_in_group("obj"):
			var t = b as RigidBody2D
			print(collision.get_normal())
			#print("prechange vel: ", self.linear_velocity)
			if collision.get_normal().y > 0:
				print("obj on top!")
				weight += t.mass * collision.get_normal().y
	return weight
