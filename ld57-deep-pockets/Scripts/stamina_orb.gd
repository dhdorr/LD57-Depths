extends Node2D
@onready var area_2d: Area2D = $Area2D
var isRecharged = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not isRecharged:
		return
	SignalBus.restore_stamina.emit(25)
	self.visible = false
	isRecharged = false
	area_2d.monitorable = false
	area_2d.monitoring = false
	var timer := get_tree().create_timer(3.0)
	timer.timeout.connect(RespawnOrb)


func RespawnOrb() -> void:
	self.visible = true
	isRecharged = true
